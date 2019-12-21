defmodule Shorty.LinksTest do
  use Shorty.DataCase

  alias Shorty.Links

  describe "links" do
    alias Shorty.Links.Link

    @valid_attrs %{shortcode: "Xf24g4", url: "https://www.impraise.com"}
    @invalid_attrs %{shortcode: "an invalid shortcode", url: "https://www.impraise.com"}
    @valid_attrs_without_shortcode %{url: "https://www.impraise.com"}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Links.create_link()

      link
    end

    test "create_link/1 creates a link with valid url and with a shortcode" do
      assert {:ok, %Link{} = link} = Links.create_link(@valid_attrs)

      assert link.shortcode == @valid_attrs[:shortcode]
      assert link.url == @valid_attrs[:url]
    end

    test "create_link/1 creates a link with a valid url and without a shortcode" do
      assert {:ok, %Link{} = link} = Links.create_link(@valid_attrs_without_shortcode)

      #assert link.shortcode == @valid_attrs_without_shortcode[:shortcode]
      assert Regex.match?( ~r/^[0-9a-zA-Z_]{6}$/, link.shortcode)
      assert link.url == @valid_attrs_without_shortcode[:url]
    end

    test "create_link/1 doesnt create a link with an invalid shortcode" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "create_link/1 doesnt create a link without a url" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(%{})
    end

    test "get_link_by_shortcode/1 returns the link with given shortcode" do
      link = link_fixture()
      assert Links.get_link_by_shortcode(link.shortcode) == link
    end
  end
end
