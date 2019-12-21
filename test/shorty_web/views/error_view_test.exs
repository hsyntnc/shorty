defmodule ShortyWeb.ErrorViewTest do
  use ShortyWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(ShortyWeb.ErrorView, "404.json", []) == %{errors: %{detail: "The shortcode cannot be found in the system"}}
  end

  test "renders 400.json" do
    assert render(ShortyWeb.ErrorView, "400.json", []) == %{errors: %{detail: "You must provide a url."}}
  end

  test "renders 409.json" do
    assert render(ShortyWeb.ErrorView, "409.json", []) == %{errors: %{detail: "The the desired shortcode is already in use."}}
  end

end
