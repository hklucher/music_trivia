import MusicQuiz.Seeds.Artists
# require IEx;
# alias MusicQuiz.Spotify
#
# defmodule MusicQuiz.Seeds do
#   alias MusicQuiz.{Repo, Genre, Artist, Album, Quiz, Answer, Question, Response}
#
#   def artists(start_year, end_year) do
#     Enum.each(start_year..end_year, fn(year) ->
#       %HTTPoison.Response{body: %{"artists" => artists}} = Spotify.get!("search?q=year%3A#{year}&type=artist")
#       insert_artists(artists)
#     end)
#   end
#
  # defp insert_artists(json) do
  #   %{"href" => _, "items" => artists} = json
  #   Enum.each(artists, fn(artist) ->
  #     attributes = parse_artist_attributes(artist)
  #     case Repo.insert(Artist.changeset(%Artist{}, attributes)) do
  #       {:ok, changeset} ->
  #         build_artist_genres(changeset, artist["genres"])
  #       {:error, changeset} ->
  #         IO.puts "Error: artist already exists, continuing without insertion."
  #     end
  #   end)
  # end
#
#   defp parse_artist_attributes(artist_map) do
#     artist_map
#     |> Map.take(["name", "popularity", "id"])
#     |> Map.put("spotify_id", artist_map["id"])
#     |> Map.delete("id")
#     |> Map.put("image_url", get_image_url(artist_map))
#   end
#
#   defp get_image_url(map), do: (Enum.at(map["images"], 0))["url"]
#
#   defp build_artist_genres(artist, genres) do
#     Enum.each(genres, fn(genre) ->
#       case Repo.insert(Genre.changeset(%Genre{}, %{name: genre})) do
#         {:ok, changeset} ->
#           changeset
#           |> Repo.preload(:artists)
#           |> Ecto.Changeset.change
#           |> Ecto.Changeset.put_assoc(:artists, [artist])
#           |> Repo.update!
#         {:error, _changeset} ->
#           genre = Repo.get_by!(Genre, name: genre) |> Repo.preload(:artists)
#           genre
#           |> Ecto.Changeset.change
#           |> Ecto.Changeset.put_assoc(:artists, genre.artists ++ [artist])
#           |> Repo.update!
#       end
#     end)
#   end
#
#   def albums do
#     Enum.each(Repo.all(Artist), fn(artist) ->
#       case Spotify.albums(artist.spotify_id) do
#         {:ok, albums} ->
#           Enum.each(albums["items"], fn(album) ->
#             create_album(album["id"], artist)
#             :timer.sleep(2500)
#           end)
#         {:error, message} ->
#           IO.puts "Error creating album."
#       end
#     end)
#   end
#
#   defp create_album(spotify_id, artist) do
#     case Spotify.album(spotify_id) do
#       {:ok, album_data} ->
#         attributes = parse_album_attributes(album_data, artist)
#         case Repo.insert(Album.changeset(%Album{}, attributes)) do
#           {:ok, changeset} ->
#             IO.puts "Created album"
#           {:error, changeset} ->
#             IO.puts "Error: Did not insert album, continuing..."
#         end
#       {:error, message} ->
#         IO.puts "Error: #{message}"
#         System.halt(0)
#     end
#   end
#
#   def parse_album_attributes(album, artist) do
#     album
#     |> Map.take(["name", "id"])
#     |> Map.put("spotify_id", album["id"])
#     |> Map.delete("id")
#     |> Map.put("image_url", get_image_url(album))
#     |> Map.put("artist_id", artist.id)
#   end
#
#   def quizzes do
#     Enum.each((Repo.all(Genre) |> Repo.preload(:quizzes)), fn(genre) ->
#       {:ok, quiz} = Repo.insert(Quiz.changeset(%Quiz{}, %{name: "#{genre.name} quiz"}))
#       genre
#       |> Ecto.Changeset.change
#       |> Ecto.Changeset.put_assoc(:quizzes, genre.quizzes ++ [quiz])
#       |> Repo.update!
#     end)
#   end
#
#   def questions do
#     Enum.each(Repo.all(Quiz) |> Repo.preload(:genre), fn(quiz) ->
#       artists = Repo.preload(Artist.by_genre(quiz.genre.id), :albums)
#       Enum.each(artists, fn(artist) ->
#         artist_albums = artist.albums
#         unless Enum.empty?(artist_albums) do
#           {:ok, correct_answer} = Repo.insert(Answer.changeset(%Answer{}, %{content: Enum.random(artist_albums).name}))
#           question_text = "Which of these albums was put out by '#{artist.name}'?"
#           question = insert_question(question_text, correct_answer, quiz)
#           insert_distractors(artist, question)
#         end
#       end)
#     end)
#   end
#
#   def insert_distractors(artist, question) do
#     distractors = incorrect_answers(Artist.not_owned_albums(artist.id))
#     Enum.each(distractors, fn(distractor) ->
#       Repo.insert!(Response.changeset(%Response{}, %{content: distractor.name, question_id: question.id}))
#     end)
#   end
#
#   def insert_question(content, answer, quiz) do
#     case Repo.insert(Question.changeset(%Question{}, %{content: content})) do
#       {:ok, changeset} ->
#         changeset
#         |> Repo.preload(:answer)
#         |> Repo.preload(:quizzes)
#         |> Ecto.Changeset.change
#         |> Ecto.Changeset.put_assoc(:answer, answer)
#         |> Ecto.Changeset.put_assoc(:quizzes, Repo.preload(changeset, :quizzes).quizzes ++ [Repo.preload(quiz, :questions)])
#         |> Repo.update!
#       {:error, _changeset} ->
#         IO.puts "Error inserting question, terminating."
#         System.halt(0)
#     end
#   end
#
#   defp incorrect_answers(albums), do: Enum.take_random(albums, 3)
# end
#
# Spotify.start
# MusicQuiz.Seeds.artists(1970, 1972)
# MusicQuiz.Seeds.albums
# # MusicQuiz.Seeds.quizzes
# # MusicQuiz.Seeds.questions


Spotify.start
MusicQuiz.Seeds.Artists.seed(1975, 1977)
MusicQuiz.Seeds.Albums.seed
MusicQuiz.Seeds.Quizzes.seed
