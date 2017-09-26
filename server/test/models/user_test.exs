defmodule Commently.UserTest do
  use Commently.ModelCase

  alias Commently.User

  @valid_attrs %{avatar: "some content", name: "some content", secret: "some content", token: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
