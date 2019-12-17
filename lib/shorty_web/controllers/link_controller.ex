defmodule ShortyWeb.LinkController do
  use ShortyWeb, :controller

  alias Shorty.Links
  alias Shorty.Links.Link

  action_fallback ShortyWeb.FallbackController

  def create(conn, link_params) do
    with {:ok, %Link{} = link} <- Links.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"shortcode" => shortcode}) do
    with link = Links.get_link_by_shortcode(shortcode) do
      case link do
        nil -> 
          conn 
          |> put_status(:not_found)
          |> put_view(ShortyWeb.ErrorView)
          |> render(:"404")
        record -> 
          conn
          |> put_resp_header("Loaction", record.url)
          |> send_resp(302, "")
        end
    end
  end

  def stats(conn, %{"shortcode" => shortcode}) do
    with link = Links.get_link_by_shortcode(shortcode) do
      case link do
        nil -> 
          conn 
          |> put_status(:not_found)
          |> put_view(ShortyWeb.ErrorView)
          |> render(:"404")
        record -> 
          conn
          |>render("stats.json", link: record)
        end
    end
  end
end
