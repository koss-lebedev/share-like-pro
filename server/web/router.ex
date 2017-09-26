defmodule Commently.Router do
  use Commently.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Commently do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/:resource/comments/*path", ResourceController, :show
    get "/:resource/posts/*path", ResourceController, :new
    post "/:resource/posts/*path", ResourceController, :create
  end

  scope "/api", Commently do
    pipe_through :api

    get "/:resource/comments/*path", ResourceController, :index
  end

  scope "/auth", Commently do
      pipe_through [:browser]

      get "/:provider", AuthController, :request
      get "/:provider/callback", AuthController, :callback
      post "/:provider/callback", AuthController, :callback
      delete "/logout", AuthController, :delete
    end

end
