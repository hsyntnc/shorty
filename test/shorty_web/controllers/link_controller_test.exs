defmodule ShortyWeb.LinkControllerTest do
  use ShortyWeb.ConnCase

  alias Shorty.Links
  alias Shorty.Links.Link

  @link_without_code %{
    url: "https://www.impraise.com"
  }

  @valid_link_attrs %{
    shortcode: "imprse",
    url: "https://www.impraise.com"
  }

  @invalid_link_attrs %{
    shortcode: "an invalid shortcode",
    url: "https://www.impraise.com"
  }

  def fixture(:link) do
    {:ok, link} = Links.create_link(@valid_link_attrs)
    link
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "shortcode generation" do
    test "create a shortcode with a valid code given", %{conn: conn} do
      response =
        conn
        |> post("/shorten", @valid_link_attrs)
        |> json_response(201)

      expected = %{ "shortcode" => @valid_link_attrs[:shortcode] }

      assert expected === response
    end

    test "create a shortcode without a shortcode", %{conn: conn} do
      response =
        conn
        |> post("/shorten", @link_without_code)
        |> json_response(201)
    end

    test "returns an error without a url", %{ conn: conn } do
      response =
        conn
        |> post("/shorten", %{})
        |> json_response(400)

      assert response["errors"] != %{}
    end

    test "returns an error if given shortcode is not valid", %{conn: conn} do
      response =
        conn
        |> post("/shorten", @invalid_link_attrs)
        |> json_response(422)

      assert response["errors"] != %{}
    end

    test "returns an error if given shortcode is already in use", %{conn: conn} do
      response =
        conn
        |> post("/shorten", @valid_link_attrs)
    end
  end

  describe "shortcode endpoint" do
    setup [:create_link]

    test "returns 302 if shortcode was found", %{conn: conn, link: link} do
      response =
        conn
        |> get("/#{link.shortcode}")
        |> response(302)

      expected = ""

      assert response == expected
    end

    test "returns 404 if shortcode was not found", %{conn: conn} do
      response =
        conn
        |> get("/an_invalid_shortcode")
        |> json_response(404)

      assert response["errors"] != %{}
    end
  end

  describe "shortcode stats" do
    setup [:create_link]

    test "returns shortcode stats with an existing code", %{conn: conn, link: link} do
      response =
        conn
        |> get("/#{link.shortcode}/stats")
        |> json_response(200)

      assert response["startDate"] == String.replace(DateTime.to_string(link.inserted_at), " ", "T")
      assert response["lastSeenDate"] == String.replace(DateTime.to_string(link.updated_at), " ", "T")
      assert response["redirectCount"] == link.redirect_count
    end

    test "returns 404 if shortcode was not found", %{conn: conn} do
      response =
        conn
        |> get("/an_invalid_shortcode")
        |> json_response(404)

      assert response["errors"] != %{}
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link: link}
  end
end
