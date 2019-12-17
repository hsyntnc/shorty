defmodule Shorty.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :shortcode, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:links, [:shortcode])
  end
end
