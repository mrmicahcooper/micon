defmodule MiconWeb.PageController do
  use MiconWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
