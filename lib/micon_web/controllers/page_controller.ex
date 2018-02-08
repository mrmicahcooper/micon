defmodule MiconWeb.PageController do
  use MiconWeb, :controller

  def index(conn, _params) do
    svgs = Micon.Svg.all()

    conn
    |> render("index.html", svgs: svgs)
  end

  def show(conn, _params) do
    path = conn.request_path
    svgs = Micon.Svg.get(path)

    conn
    |> put_resp_content_type("image/svg+xml")
    |> render("show.svg", svgs: svgs)
  end
end
