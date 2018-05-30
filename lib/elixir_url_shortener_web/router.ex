defmodule ElixirUrlShortenerWeb.Router do
  use ElixirUrlShortenerWeb, :router

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

  scope "/", ElixirUrlShortenerWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:short_code", PageController, :use_short_code
    post "/create_short_code", PageController, :shorten_url
  end

  # Other scopes may use custom stacks.
  # scope "/api", ElixirUrlShortenerWeb do
  #   pipe_through :api
  # end
end
