defmodule ShortyWeb.LinkController do
  use ShortyWeb, :controller

  alias Shorty.Links
  alias Shorty.Links.Link

  action_fallback ShortyWeb.FallbackController

  def create(conn, link_params) do
    conn = conn
    |> check_url_existence(%{})
    |> check_shortcode_uniqueness(%{})

    with {:ok, %Link{} = link} <- Links.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"shortcode" => _shortcode}) do
    link = set_shortcode(conn, %{})

    conn
    |> put_resp_header("location", link.url)
    |> send_resp(302, "")
  end

  def stats(conn, %{"shortcode" => _shortcode}) do
    link = set_shortcode(conn, %{})

    conn
    |> render("stats.json", link: link)
  end

  defp set_shortcode(conn, _) do
    with link = Links.get_link_by_shortcode(conn.params["shortcode"]) do
      case link do
        nil ->
          conn
          |> put_status(:not_found)
          |> put_view(ShortyWeb.ErrorView)
          |> render(:"404")
        record ->
          record
        end
    end
  end

  defp check_url_existence(conn, _) do
    if is_nil(conn.params["url"]) do
      conn
      |> put_status(:bad_request)
      |> put_view(ShortyWeb.ErrorView)
      |> render("400.json")
    end
    conn
  end

  defp check_shortcode_uniqueness(conn, _) do
    unless is_nil(conn.params["shortcode"]) do
      with link = Links.get_link_by_shortcode(conn.params["shortcode"]) do
        case link do
          nil ->
            conn
          _record ->
            conn
            |> put_status(409)
            |> put_view(ShortyWeb.ErrorView)
            |> render("409.json")
          end
      end
    end
    conn
  end
end
