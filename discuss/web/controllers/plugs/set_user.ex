defmodule Discuss.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller
# used to adding the user object to the connection, so plugs down the pipeline can have access to the user object
  alias Discuss.Repo
  alias Discuss.User

  def init(_params) do
  end

  def call(conn, _params) do
    # gets run each time
    user_id = get_session(conn, :user_id)

    cond do 
      # condition statement looks similar to a case statement but behaves differently. 
      # we can add a variety of situations in here. Here, the first boolean expression that evaluates to true, the block that is under it is executed
      user = user_id && Repo.get(User, user_id) -> 
        # set the assigns property in the connection to user
        assign(conn, :user, user)
      true -> 
        # if the above fails, this runs always. So if we cant find a user, then we run this. Its equivalent to Else
        assign(conn, :user, nil)
    end
  end
end