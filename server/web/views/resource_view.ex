defmodule Commently.ResourceView do
  use Commently.Web, :view

  def render("show.json", %{text: text, title: title, by: by}) do
    %{ title: title, text: text, by: by }
  end

end
