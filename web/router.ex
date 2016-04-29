defmodule Tunedrop.Router do
  use Tunedrop.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Tunedrop.Auth, repo: Tunedrop.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug Tunedrop.ApiAuth, repo: Tunedrop.Repo
  end

  pipeline :apihelper do
    plug :accepts, ["json"]
  end

  scope "/", Tunedrop do
    pipe_through :browser # Use the default browser stack

    get "/", TuneController, :index
    get "/welcome", PageController, :index

    resources "/users", UserController, only: [:index, :show, :new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/tunes", TuneController, only: [:index]
    resources "/spotify", SpotifyController, only: [:show]
  end

  # Other scopes may use custom stacks.
  scope "/api", Tunedrop do
    pipe_through [:api, :authenticate_api]

    resources "/songs", SongController, only: [:index, :create, :show]
  end

  scope "/apihelper", Tunedrop do
    pipe_through [:apihelper]

    resources "/youtube", YoutubeController, only: [:show]
  end
end
