require IEx;
defmodule MusicQuiz.Seeds.Questions.MatchYearToAlbums do
  alias MusicQuiz.{Repo, Quiz, Genre, Spotify, Answer, Response}

  @chars_in_year 4

  def seed, do: seed(quizzes: Repo.all(Quiz))
  def seed(quizzes: []), do: :ok

  def seed(quizzes: [quiz | tail]) do
    quiz_genre = Repo.preload(quiz, :genre).genre
    genre_albums = Repo.preload(Genre.albums(quiz_genre), :artist)
    seed(albums: genre_albums)
    seed(quizzes: tail)
  end

  def seed(albums: [album | tail]) do
    {:ok, album_info} = Spotify.album(album.spotify_id)
    question_content = "What year was the album #{album.name} by #{album.artist.name} released?"
    answer = insert_or_find_answer(release_year(album_info["release_date"]))
    distractors = insert_or_find_distractors(answer.content)
    IO.inspect distractors
    :timer.sleep(1000)
    seed(albums: tail)
  end

  def seed(albums: []), do: :ok
  defp release_year(year), do: String.slice(year, 0, @chars_in_year)

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

# FOR EACH quiz IN quizzes
  # GET genre for current quiz
  # GET list of albums for current genre
  # FOR EACH album IN albums
    # Build answer content of '{album release year}'
      # INSERT answer
    # Build distractors: SEE build_distractors pseudocode
      # FOR EACH distractor IN distractors
        # INSERT distractor
      # END FOR
      # RETURN list of inserted distractors
    # Build question with content 'What year was the album {album title} by {album artist} released?'
    # IF question is successfully INSERTED
      # PRELOAD associations answer and responses
      # Build a changeset to associate answer and responses with already inserted answer and responses
      # UPDATE changeset
    # ELSE
      # The question is likely already in existence, simply find that question and
      # associate it with the current quiz
    # END IF
  # END FOR
# END FOR

# Build Distractors
  # INPUT: Actual release year of album (correct answer)
  # OUTPUT: A list of inserted Response structs
  # SET lower_bound TO year MINUS 10
  # IF input year + 10 IS NOT in the future
    # SET upper_bound TO year PLUS 10
  # ELSE
    # SET upper_bound TO current year
  # END IF
  # MAP lower bound to upper bound as list
  # TAKE three random items from list that ARE NOT year
  # FOR EACH year IN year_list
    # INSERT a distractor with that content
  # END FOR
  # RETURN mapped disractor list
