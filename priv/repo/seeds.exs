# Require and load all seed modules.
Path.wildcard("priv/repo/seeds/**/*.exs")
|> Enum.map(&Code.require_file/1)

# To customize seeds, comment/uncomment what is needed for the data base. To customize
# items for functions that take lists (like albums and tracks), simply replace
# the current DB call with a different query.

MusicQuiz.Spotify.start
# MusicQuiz.Seeds.Artists.seed(1975, 1977)
# MusicQuiz.Seeds.Albums.seed(%{"artist_range" => MusicQuiz.Repo.all(MusicQuiz.Artist, limit: 4)})
# MusicQuiz.Seeds.Tracks.seed(%{"album_range" => MusicQuiz.Repo.all(MusicQuiz.Album, limit: 10)})
# MusicQuiz.Seeds.Quizzes.seed
# MusicQuiz.Seeds.Questions.MatchSongsToAlbums.seed
# MusicQuiz.Seeds.Questions.TrackLengths.seed
