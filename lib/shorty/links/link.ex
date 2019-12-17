defmodule Shorty.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :shortcode, :string
    field :url, :string
    field :redirect_count, :integer, default: 0
    timestamps([type: :utc_datetime_usec])
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:shortcode, :url])
    |> validate_required([:shortcode, :url])
    |> validate_shortcode
    |> validate_url
    |> unique_constraint(:shortcode)
  end

  @doc false
  defp validate_shortcode(changeset) do
    shortcode = get_field(changeset, :shortcode)
    if Regex.match?(~r/^[0-9a-zA-Z_]{6}$/, shortcode) do
      changeset
    else
      add_error(changeset, :shortcode, "Should match with ^[0-9a-zA-Z_]{6}$.")
    end
  end

  @doc false
  defp validate_url(changeset) do
    url = get_field(changeset, :url)
    if Regex.match?(~r/^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/, url) do
      changeset
    else
      add_error(changeset, :url, "It's not a valid url.")
    end
  end
end
