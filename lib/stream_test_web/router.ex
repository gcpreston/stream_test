defmodule StreamTestWeb.Router do
  use StreamTestWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {StreamTestWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", StreamTestWeb do
    pipe_through :browser

    get "/", PageController, :home

    live "/models", ModelLive.Index, :index
    live "/models/new", ModelLive.Index, :new
    live "/models/:id/edit", ModelLive.Index, :edit

    live "/models/:id", ModelLive.Show, :show
    live "/models/:id/show/edit", ModelLive.Show, :edit

    live "/single", SingleLive, :index
    live "/assign", AssignLive, :index
    live "/nested", NestedLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamTestWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:stream_test, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: StreamTestWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
