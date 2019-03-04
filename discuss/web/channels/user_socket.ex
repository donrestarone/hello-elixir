defmodule Discuss.UserSocket do
  use Phoenix.Socket

  # this behaves similar to the router. This is basically a wildcard route.
  channel "comments:*", Discuss.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket


  # get the token from the params passed from socket.js
  def connect(%{"token" => token}, socket) do
    # the "key" is the key we used to encode the token, replace it with a secret soon
    case Phoenix.Token.verify(socket, "key", token) do
      {:ok, user_id} -> 
        {:ok, assign(socket, :user_id, user_id)}
      {:error, _error} -> 
        :error
    end
    {:ok, socket}
  end

  def id(_socket), do: nil
end
