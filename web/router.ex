defmodule MusicQuiz.Router do
  use MusicQuiz.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
  end

  pipeline :browser_auth do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.EnsureAuthenticated, handler: MusicQuiz.Token
    plug Guardian.Plug.LoadResource
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MusicQuiz do
    pipe_through :browser # Use the default browser stack

    get "/", QuizController, :index
    resources "/genres", GenreController, only: [:index, :show]
    resources "/artists", ArtistController, only: [:index, :show]
    resources "/quizzes", QuizController, only: [:show, :index]
    resources "/registrations", RegistrationController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create]
    delete "/sessions", SessionController, :delete
  end

  scope "/", MusicQuiz do
    pipe_through [:browser, :browser_auth]
    resources "/users", UserController, only: [:show, :index]
  end

  scope "/api", MusicQuiz do
    pipe_through :api
    get "/quizzes/:id", Api.QuizController, :show
    post "/users/:user_id/completed_quizzes", Api.CompletedQuizController, :create
  end
end
