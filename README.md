# MusicQuiz

A simple music trivia quiz, using data seeded from Spotify's Web API.

This application is built using an Elixir/Phoenix back end with a partial React front end.

## Specifications
* Elixir Version: 1.3.4
* Phoenix Version: 1.2.1

## Usage
 To view the application in production, visit: https://stormy-falls-82572.herokuapp.com/

To run locally:
* `$ git clone https://github.com/hklucher/music_trivia.git`
* `$ mix ecto.create`
* `$ mix ecto.migrate`
*  Running the seeds:
  * Because of the sheer amount of data that can be returned from Spotify's API, the seeds are structured in a way that allows for maximum control over when different pieces of data are created.
  * To run seeds in entirety (note: these scripts will run for a long time), simply uncomment all function calls in `seeds.exs` and then run `$ mix run priv/repo/seeds.exs` from the projects root.
  * To control how much data is fetched from Spotify, adjust the arguments passed to the function calls in `seeds.exs`. (For example: to seed more albums for artists, increase the limit argument passed to the artist query when calling `MusicQuiz.Seeds.Albums.seed`)
