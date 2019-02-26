defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth
  
  alias Discuss.User

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    # callback is expected by Ueberauth for the callback from github
    # from the connection, get the auth code returned by github
    user_params = %{token: auth.credentials.token, email: auth.info.email, provider: to_string(auth.provider) }
    # cast the params coming from github, and build a structure that can be inserted into the database
    changeset = User.changeset(%User{}, user_params)
    # save the user or not + encode session cookie
    signin(conn, changeset)
  end

  def signout(conn, _params) do
    # clear the session cookie
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} -> 
        conn
        |> put_flash(:info, "Welcome Back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} -> 
        conn
        |> put_flash(:error, "Error signing in")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update_user(changeset) do
    # changeset tracks the diff. So thats why we are reaching out to changes
    case Repo.get_by(User, email: changeset.changes.email) do
      # if a user is not found, then we save
      nil ->  
        Repo.insert(changeset)
      user -> 
        {:ok, user}
    end
  end
end