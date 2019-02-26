defmodule Discuss.Router do
  use Discuss.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Discuss.Plugs.SetUser
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Discuss do
    pipe_through :browser # Use the default browser stack

    get "/", TopicController, :index
    get "/topics/new", TopicController, :new
    post "/topics", TopicController, :create
    get "/topics/:id/edit", TopicController, :edit
    put "/topics/:id", TopicController, :update
    delete "/topics/:id", TopicController, :delete

    # ^^ to generate the above, use a resources helper
    # resources "/", TopicController
  end

  scope "/auth", Discuss do
    # for Oauth via github, scoping everything to /auth/* namespace
    pipe_through :browser # Use the default browser stack
    # request method is automatically defined by ueberauth module. Provider will be subbed in by ueberauth for github/facebook whatever strategy you have configured. This is for the initial o auth request
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end 

  # Other scopes may use custom stacks.
  # scope "/api", Discuss do
  #   pipe_through :api
  # end
end
