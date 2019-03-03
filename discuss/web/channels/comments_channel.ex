defmodule Discuss.CommentsChannel do
  use Discuss.Web, :channel

  alias Discuss.{Repo, Topic, Comment}

  # vvvv `comments:${topicId}` grabs the topic id coming from js
  def join("comments:" <> topic_id, _params, socket) do
    topic_id = String.to_integer(topic_id)
    topic = Topic |> Repo.get(topic_id) |> Repo.preload(:comments)

    # encode the topic id to the socket, so that handle_in will have access to it when associating comments with a topic
    # give the comments in a map 
    {:ok, %{comments: topic.comments}, assign(socket, :topic, topic)}
  end

  def handle_in(name, %{"content" => content}, socket) do 
    topic = socket.assigns.topic

    changeset = topic
    |> build_assoc(:comments)
    |> Comment.changeset(%{content: content})

    case Repo.insert(changeset) do
      {:ok, comment} -> 
        {:reply, :ok, socket}
      {:error, _reason} -> 
        {:reply, { :error, %{errors: changeset} }, socket}
    end
  end
end