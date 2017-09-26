defmodule UserFromAuth do

  alias Ueberauth.Auth

  def find_or_create(%Auth{} = auth) do
    {:ok, insert_or_update(auth)}
  end

  defp insert_or_update(auth) do
    external_id = auth.uid
    changes = %{
      external_id: external_id,
      name: name_from_auth(auth),
      avatar: auth.info.image,
      token: to_string(auth.credentials.token) ,
      secret: to_string(auth.credentials.secret)
    }

    result =
      case Commently.Repo.get_by(Commently.User, external_id: external_id) do
        nil  -> %Commently.User{external_id: external_id}
        post -> post
      end
      |> Commently.User.changeset(changes)
      |> Commently.Repo.insert_or_update!
  end

  defp name_from_auth(auth) do
    if auth.info.name do
      auth.info.name
    else
      name = [auth.info.first_name, auth.info.last_name]
      |> Enum.filter(&(&1 != nil and &1 != ""))

      cond do
        length(name) == 0 -> auth.info.nickname
        true -> Enum.join(name, " ")
      end
    end
  end

end