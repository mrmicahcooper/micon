defmodule MiconWeb.Router do
  use MiconWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers
  end

  scope "/", MiconWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/icons/*path", PageController, :show
  end
end
