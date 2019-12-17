defmodule ShortyWeb.Router do
  use ShortyWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ShortyWeb do
    pipe_through :api

    post "/shorten", LinkController, :create
    get "/:shortcode", LinkController, :show
    get "/:shortcode/stats", LinkController, :stats
  end
end
