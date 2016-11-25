defmodule MusicQuiz.Seeds.Questions.MatchYearToAlbums do
  alias MuiscQuiz.{Spotify, Question, Repo, Answer, Response}

  @characters_in_year 4

  def seed([album | tail]) do
    insert_question_with_associations(Spotify.album(album.spotify_id))
    :timer.sleep(1500)
    seed(tail)
  end

  def seed([]), do: :ok

  defp insert_question_with_associations({:ok, response}) do
    answer = insert_answer(response)
    distractors = insert_distractors(response)
    question = insert_question(response)
  end

  defp insert_question(response, answer: answer, distractors: distractors) do
    question_text = "In what year was the album #{resonse["name"]} released?"
    case Repo.insert(%Question{}, %{content: question_text}) do
      {:ok, changeset} ->
        question = Repo.preload(changeset, [:answer, :responses])
        question
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Ecto.Changeset.put_assoc(:responses, question.responses ++ distractors)
        |> Repo.update!
      {:error, changeset} ->
        IO.puts "Error inserting question, terminating."
        System.halt(0)
    end
  end

  defp insert_question_with_associations({:error, response}, _album) do
    IO.puts response
    System.halt(0)
  end

  defp insert_answer(album) do
    year = String.slice(album["release_date"], 0, @characters_in_year)
    Repo.insert!(Answer.changeset(%Answer{}, %{content: year}))
  end

  defp insert_distractors(album) do
    year = String.slice(album["release_date"], 0, @characters_in_year)
    Enum.map(distractor_years(year), fn(y) ->
      {:ok, changeset} = Repo.insert(%Response{}, %{content: y})
    end)
  end

  defp distractor_years(year) do
    lower_bound = String.to_integer - 10
    upper_bound = String.to_integer + 10
    Enum.to_list(lower_bound..upper_bound)
    |> Enum.reject(fn(y) -> y == String.to_integer(year) end)
    |> Enum.take_random(3)
  end
end

# FOR EACH album IN albums
  # Hit spotify API with album's spotify id
  # IF response is 200
    # Get album release year
    # Insert question 'What year was this album released?'
    # IF insertion is complete
      # Insert answer with albums year
      # Get years within 20 years of album (+ or - 10), select three that aren't release year
      # Insert those as responses
      # Associate with question
  # ELSE
    # Terminate
  # END IF
# END FOR
