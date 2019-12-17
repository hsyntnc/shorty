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
    |> unique_constraint(:shortcode)
  end
end
