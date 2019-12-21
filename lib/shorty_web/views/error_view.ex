defmodule ShortyWeb.ErrorView do
  use ShortyWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.json", _assigns) do
  #   %{errors: %{detail: "Internal Server Error"}}
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.json" becomes
  # "Not Found".
  def template_not_found(_, _assigns) do
    %{errors: %{detail: "Internal server error"}}
  end

  def render("404.json", _ssigns) do
    %{errors: %{detail: "The shortcode cannot be found in the system"}}
  end

  def render("400.json", _assigns) do
    %{errors: %{detail: "You must provide a url."}}
  end

  def render("409.json", _assigns) do
    %{errors: %{detail: "The the desired shortcode is already in use."}}
  end
end
