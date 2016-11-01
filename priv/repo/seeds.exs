require IEx;
alias MusicQuiz.Repo
alias MusicQuiz.Genre
alias MusicQuiz.Artist
alias MusicQuiz.Album
alias MusicQuiz.Spotify
alias MusicQuiz.Quiz
alias MusicQuiz.Answer
alias MusicQuiz.Question

defmodule MusicQuiz.Seeds do
  def artists(start_year, end_year) do
    Enum.each(start_year..end_year, fn(year) ->
      %HTTPoison.Response{body: %{"artists" => artists}} = Spotify.get!("search?q=year%3A#{year}&type=artist")
      insert_artists(artists)
    end)
  end

  defp insert_artists(json) do
    %{"href" => _, "items" => artists} = json
    Enum.each(artists, fn(artist) ->
      attributes = parse_artist_attributes(artist)
      case Repo.insert(Artist.changeset(%Artist{}, attributes)) do
        {:ok, changeset} ->
          build_artist_genres(changeset, artist["genres"])
        {:error, changeset} ->
          IO.puts "Error: artist already exists, continuing without insertion."
      end
    end)
  end

  defp parse_artist_attributes(artist_map) do
    artist_map
    |> Map.take(["name", "popularity", "id"])
    |> Map.put("spotify_id", artist_map["id"])
    |> Map.delete("id")
    |> Map.put("image_url", get_image_url(artist_map))
  end

  # TODO: Pattern match on argument?
  defp get_image_url(map), do: (Enum.at(map["images"], 0))["url"]

  defp build_artist_genres(artist, genres) do
    Enum.each(genres, fn(genre) ->
      case Repo.insert(Genre.changeset(%Genre{}, %{name: genre})) do
        {:ok, changeset} ->
          changeset
          |> Repo.preload(:artists)
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, [artist])
          |> Repo.update!
        {:error, _changeset} ->
          genre = Repo.get_by!(Genre, name: genre) |> Repo.preload(:artists)
          genre
          |> Ecto.Changeset.change
          |> Ecto.Changeset.put_assoc(:artists, genre.artists ++ [artist])
          |> Repo.update!
      end
    end)
  end

  def albums do
    Enum.each(Repo.all(Artist), fn(artist) ->
      case Spotify.albums(artist.spotify_id) do
        {:ok, albums} ->
          Enum.each(albums["items"], fn(album) ->
            create_album(album["id"], artist)
            :timer.sleep(5000)
          end)
        {:error, message} ->
          IO.puts "Error creating album."
      end
    end)
  end

  defp create_album(spotify_id, artist) do
    case Spotify.album(spotify_id) do
      {:ok, album_data} ->
        attributes = parse_album_attributes(album_data, artist)
        case Repo.insert(Album.changeset(%Album{}, attributes)) do
          {:ok, changeset} ->
            IO.puts "Created album"
          {:error, changeset} ->
            IO.puts "Error: Did not insert album, continuing..."
        end
      {:error, message} ->
        IO.puts "Error: #{message}"
        System.halt(0)
    end
  end

  def parse_album_attributes(album, artist) do
    album
    |> Map.take(["name", "id"])
    |> Map.put("spotify_id", album["id"])
    |> Map.delete("id")
    |> Map.put("image_url", get_image_url(album))
    |> Map.put("artist_id", artist.id)
  end

  def quizzes do
    Enum.each((Repo.all(Genre) |> Repo.preload(:quizzes)), fn(genre) ->
      {:ok, quiz} = Repo.insert(Quiz.changeset(%Quiz{}, %{name: "#{genre.name} quiz"}))
      genre
      |> Ecto.Changeset.change
      |> Ecto.Changeset.put_assoc(:quizzes, genre.quizzes ++ [quiz])
      |> Repo.update!
    end)
  end

  def questions do
    Enum.each(Repo.all(Quiz) |> Repo.preload(:genre), fn(quiz) ->
      artists = Artist.by_genre(quiz.genre.id)
      Enum.each(artists, fn(artist) ->
        artist = Repo.get!(Artist, elem(artist, 0)) |> Repo.preload(:albums)
        artist_albums = artist.albums
        if length(artist_albums) > 0 do
          non_artist_albums = Artist.not_owned_albums(artist.id)
          incorrect_answers = incorrect_answers(non_artist_albums)
          {:ok, correct_answer} = Repo.insert(Answer.changeset(%Answer{}, %{content: Enum.random(artist_albums).name}))
          question_text = "Which of these albums was put out by '#{artist.name}'?"
          insert_question(question_text, correct_answer)
        end
      end)
    end)
  end

  def insert_question(content, answer) do
    case Repo.insert(Question.changeset(%Question{}, %{content: content})) do
      {:ok, changeset} ->
        changeset
        |> Repo.preload(:answer)
        |> Ecto.Changeset.change
        |> Ecto.Changeset.put_assoc(:answer, answer)
        |> Repo.update!
      {:error, _changeset} ->
        IO.puts "Error inserting question, terminating."
        System.halt(0)
    end
  end

  defp incorrect_answers(collection) do
    collection
    |> Enum.take_random(3)
    |> Enum.map(fn(tuple) -> Repo.get(Album, elem(tuple, 0)) end)
  end
end

Spotify.start
# MusicQuiz.Seeds.artists(1970, 1975)
# MusicQuiz.Seeds.albums
MusicQuiz.Seeds.quizzes
MusicQuiz.Seeds.questions

