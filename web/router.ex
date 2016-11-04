defmodule MusicQuiz.Router do
  use MusicQuiz.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MusicQuiz do
    pipe_through :browser # Use the default browser stack

    get "/", GenreController, :index
    resources "/genres", GenreController, only: [:index, :show]
    resources "/artists", ArtistController, only: [:index, :show]
    resources "/quizzes", QuizController, only: [:show]
  end

  scope "/api", MusicQuiz do
    pipe_through :api
    get "/quizzes/:id", Api.QuizController, :show
  end
end
