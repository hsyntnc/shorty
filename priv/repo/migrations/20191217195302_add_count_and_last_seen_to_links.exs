defmodule Shorty.Repo.Migrations.AddCountAndLastSeenToLinks do
  use Ecto.Migration

  def change do
    alter table("links") do
      add :redirect_count, :integer
    end
  end
end
