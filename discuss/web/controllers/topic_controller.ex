defmodule Discuss.TopicController do
  #initialize/ setup controller to behave like a controller
  # equivalent to class inheritance.
  use Discuss.Web, :controller
  # use => alias Discuss.Topic 
  # if you want to reference Discuss.Topic as simply Topic
  alias Discuss.Topic 

  # run the plug for the actions listed in the array, similar to before_action
  plug Discuss.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  # ^^ this function plug operates the same way as the module plug above
  plug :check_topic_owner when action in [:update, :edit, :delete]

  def new(conn, _params) do
    # # get the connection coming from the client. 
    # # params 
    # IO.puts "+++"
    # IO.inspect(conn.assigns)
    # IO.puts "+++"
    # IO.inspect params

    # struct = %Discuss.Topic{}    
    # params = %{}
    # changeset = Discuss.Topic.changeset(struct, params)
    # shorthand 
    changeset = Topic.changeset(%Topic{}, %{})

    # pass changeset instance to the view as @changeset
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    # pattern match to get the topic object out of params
    # take the current user from the connection, pipe it down to build association (user has many topics). this returns a topic which is then piped into Topic.changeset to cast a changeset which is to be inserted to the database
    changeset = conn.assigns.user
    |> build_assoc(:topics)
    |> Topic.changeset(topic)

    # insert changeset into database
    case Repo.insert(changeset) do
      # case statement for the return value of Repo.insert
      # Repo.insert returns a tuple 
      {:ok, _topic} -> 
        conn 
        |> put_flash(:info, "Topic Created")
        # redirect to index path => specify to, pass connection and specify the controller action
        |> redirect(to: topic_path(conn, :index))
      # if it doesnt save, we re-render the new view.
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def show(conn, %{"id" => topic_id}) do
    topic = Repo.get!(Topic, topic_id)
    render conn, "show.html", topic: topic
  end

  def index(conn, _params) do
    # to get all the topics from the database
    topics = Repo.all(Topic)
    IO.puts "+++"
    IO.inspect(conn.assigns)
    IO.puts "+++"
    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    # grab query string id params, as topic_id
    # then hit the database and fetch the topic by id
    topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(topic)

    render conn, "edit.html", changeset: changeset, topic: topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    # old_topic = Repo.get(Topic, topic_id)
    # changeset = Topic.changeset(old_topic, topic)
    # short hand for the above ^^ with pipe syntax
    old_topic = Repo.get(Topic, topic_id)
    # pass the old topic, and the new changes to create a changeset to be inserted into the database
    changeset = Topic.changeset(old_topic, topic)

    case Repo.update(changeset) do
      {:ok, _topic} -> 
        conn
        |> put_flash(:info, "Topic Updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> 
        render conn, "edit.html", changeset: changeset, topic: old_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id) |> Repo.delete!
    
    conn 
    |> put_flash(:info, "Topic Deleted")
    |> redirect(to: topic_path(conn, :index))
  end

  defp check_topic_owner(conn, _params) do
    # use pattern matching to get the topic id from the connection
    # get topic_id from params.id basically
    %{params: %{"id" => topic_id}} = conn

    if Repo.get(Topic, topic_id).user_id == conn.assigns.user.id do
      conn
    else 
      conn 
      |> put_flash(:error, "you cannot edit that")
      |> redirect(to: topic_path(conn, :index))
      |> halt()
    end
  end
end