require IEx;
defmodule MusicQuiz.Seeds.Questions.MatchYearToAlbums do
  alias MusicQuiz.{Repo, Quiz, Genre, Spotify}

  @chars_in_year 4

  def seed, do: seed(quizzes: Repo.all(Quiz))
  def seed(quizzes: []), do: :ok

  def seed(quizzes: [quiz | tail]) do
    quiz_genre = Repo.preload(quiz, :genre).genre
    genre_albums = Genre.albums(quiz_genre)
    seed(albums: genre_albums)
    seed(quizzes: tail)
  end

  def seed(albums: [album | tail]) do
    {:ok, album_info} = Spotify.album(album.spotify_id)
    album_release_year = release_year(album_info["release_date"])
    :timer.sleep(1000)
  end

  def seed(albums: []), do: :ok
  defp release_year(year), do: String.slice(year, 0, @chars_in_year)
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
