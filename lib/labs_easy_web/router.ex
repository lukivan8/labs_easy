defmodule LabsEasyWeb.Router do
  use LabsEasyWeb, :router

  pipeline :authenticate do
    plug LabsEasyWeb.Plugs.Authenticate
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", LabsEasyWeb do
    pipe_through :api
    resources "/requests", RequestController, except: [:new, :edit]
    resources "/subjects", SubjectController, except: [:new, :edit]

    post "/sign_up", UserController, :create
    post "/sign_in", SessionController, :create
    delete "/sign_out", SessionController, :delete

    scope "/restricted" do
      pipe_through :authenticate
      get "/", DefaultController, :index
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:labs_easy, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: LabsEasyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
