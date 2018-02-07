defmodule MiconWeb.PageController do
  use MiconWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, _params) do
    path = conn.request_path
    send_resp(conn, 200, path)
  end
end
