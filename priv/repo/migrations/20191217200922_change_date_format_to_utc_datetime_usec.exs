defmodule Shorty.Repo.Migrations.ChangeDateFormatToUtcDatetimeUsec do
  use Ecto.Migration

  def change do
    alter table("links") do
      modify :inserted_at, :utc_datetime_usec
      modify :updated_at, :utc_datetime_usec
    end
  end
end
