require IEx;
defmodule MusicQuiz.Seeds.Questions.MatchYearToAlbums do
  alias MusicQuiz.{Repo, Quiz, Genre, Spotify, Answer, Response, Question}

  @chars_in_year 4

  def seed, do: seed(quizzes: Repo.all(Quiz))
  def seed(quizzes: []), do: :ok

  def seed(quizzes: [quiz | tail]) do
    quiz_genre = Repo.preload(quiz, :genre).genre
    genre_albums = Repo.preload(Genre.albums(quiz_genre), :artist)
    seed(albums: genre_albums, quiz: quiz)
    seed(quizzes: tail)
  end

  def seed(albums: [album | tail], quiz: quiz) do
    {:ok, album_info} = Spotify.album(album.spotify_id)
    question_content = "What year was the album #{album.name} by #{album.artist.name} released?"
    answer = insert_or_find_answer(release_year(album_info["release_date"]))
    distractors = insert_or_find_distractors(answer.content)
    insert_question(question_content, answer, distractors, quiz)
    :timer.sleep(1000)
    seed(albums: tail, quiz: quiz)
  end

  def seed(albums: [], quiz: _), do: :ok
  defp release_year(year), do: String.slice(year, 0, @chars_in_year)

  defp insert_question(content, answer, distractors, quiz) do
    case Repo.insert(Question.changeset(%Question{}, %{content: content})) do
      {:ok, changeset} ->
        changeset = Repo.preload(changeset, [:answer, :responses, :quizzes])
        changeset
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:responses, changeset.responses ++ distractors)
        |> Ecto.Changeset.put_assoc(:quizzes, changeset.quizzes ++ [quiz])
        |> Repo.update!
      {:error, changeset} ->
        IO.inspect changeset
        System.halt(0)
    end
  end

  defp insert_or_find_answer(year) do
    case Repo.insert(Answer.changeset(%Answer{}, %{content: year})) do
      {:ok, changeset} ->
        changeset
      {:error, _changeset} ->
        Repo.get_by!(Answer, content: year)
    end
  end

  defp build_distractor_years(year) do
    lower_bound = String.to_integer(year) - 10
    {current_year, _, _} = elem(:calendar.universal_time, 0)
    upper_bound =
      if (String.to_integer(year) + 10) > current_year do
        current_year
      else
        String.to_integer(year) + 10
      end
    Enum.to_list(lower_bound..upper_bound)
    |> Enum.reject(fn(y) -> String.to_integer(year) == y end)
    |> Enum.take_random(3)
  end

  defp insert_or_find_distractors(answer_year) do
    distractors = build_distractor_years(answer_year)
    Enum.map(distractors, fn(year) ->
      case Repo.insert(Response.changeset(%Response{}, %{content: "#{year}"})) do
        {:ok, changeset} ->
          changeset
        {:error, _changeset} ->
          Repo.get_by!(Answer, content: year)
      end
    end)
  end
end
