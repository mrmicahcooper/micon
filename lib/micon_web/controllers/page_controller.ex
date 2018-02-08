defmodule MiconWeb.PageController do
  use MiconWeb, :controller

  plug :put_layout, false when action in [:show]

  def index(conn, _params) do
    svgs = Micon.Svg.all()
    grouped_svgs = Enum.group_by(svgs, &(&1.key))

    conn
    |> render("index.html", svgs: svgs, grouped_svgs: grouped_svgs)
  end

  def show(conn, _params) do
    path = conn.request_path
    svgs = Micon.Svg.get(path)

    conn
    |> put_resp_content_type("image/svg+xml")
    |> render("show.svg", svgs: svgs)
  end
end
