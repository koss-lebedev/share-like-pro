defmodule Commently.CommentView do
  use Commently.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Commently.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Commently.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      url: comment.url}
  end
end
