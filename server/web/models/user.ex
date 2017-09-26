defmodule Commently.User do
  use Commently.Web, :model

  schema "users" do
    field :external_id, :string
    field :name, :string
    field :token, :string
    field :secret, :string
    field :avatar, :string
    field :share_count, :integer
    field :error_count, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:external_id, :name, :token, :secret, :avatar, :share_count, :error_count])
    |> validate_required([:external_id, :name, :token, :secret, :avatar])
  end
end
