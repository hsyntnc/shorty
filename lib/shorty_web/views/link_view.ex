defmodule ShortyWeb.LinkView do
  use ShortyWeb, :view
  alias ShortyWeb.LinkView

  def render("show.json", %{link: link}) do
    %{shortcode: link.shortcode}
  end

  def render("stats.json", %{link: link}) do
    %{startDate: link.inserted_at, lastSeenDate: link.updated_at, redirectCount: link.redirect_count}
  end
end
