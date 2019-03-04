defmodule Discuss.UserSocket do
  use Phoenix.Socket

  # this behaves similar to the router. This is basically a wildcard route.
  channel "comments:*", Discuss.CommentsChannel

  transport :websocket, Phoenix.Transports.WebSocket


  # get the token from the params passed from socket.js
  def connect(%{"token" => token}, socket) do
    {:ok, socket}
  end

  def id(_socket), do: nil
end
