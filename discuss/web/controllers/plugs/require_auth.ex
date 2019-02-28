defmodule Discuss.Plugs.RequireAuth do
  # this plug runs after the router chooses a controller to route to
  # get access to put_flash 
  import Plug.Conn
  import Phoenix.Controller

  # to reference Helpers directly. 
  alias Discuss.Router.Helpers

  def init(_params) do
    
  end

  def call(conn, params) do
    # gets run each time
    if conn.assigns[:user] do
      # if there is a user, we simply return the connection, so they can pass through
      conn 
    else 
      conn 
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Helpers.topic_path(conn, :index))
      |> halt()
      # ^^ we have to stop the call chain. This prevents it from  hitting the next plug/controllers 
    end
  end
end