defmodule TriviumWeb.Router do
  use TriviumWeb, :router

  import TriviumWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TriviumWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
    plug TriviumWeb.GoogleAnalitycs
    plug TriviumWeb.Plugs.SetLocale
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # Other scopes may use custom stacks.
  # scope "/api", TriviumWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: TriviumWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:browser]

      forward "/mailbox", Plug.Swoosh.MailboxPreview, base_path: "/dev/mailbox"
    end
  end

  ## Authentication routes

  scope "/", TriviumWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", TriviumWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email

    live "/institutions", InstitutionLive.Index, :index
    live "/institutions/new", InstitutionLive.New, :new
    live "/institutions/:id/edit", InstitutionLive.Edit, :edit
    live "/institutions/:id", InstitutionLive.Show, :show

    live "/classrooms", ClassroomLive.Index, :index
    live "/classrooms/new", ClassroomLive.New, :new
    live "/classrooms/:id/edit", ClassroomLive.Edit, :edit
    live "/classrooms/:id", ClassroomLive.Show, :show

    live "/subjects/new", SubjectLive.New, :new
    live "/subjects/:id", SubjectLive.Show, :show
    live "/subjects/:id/edit", SubjectLive.Edit, :edit

    live "/lessons/new", LessonLive.New, :new
    live "/lessons/:id", LessonLive.Show, :show
    live "/lessons/:id/edit", LessonLive.Edit, :edit

    live "/concepts/new", ConceptLive.New, :new
    live "/concepts/:id", ConceptLive.Show, :show
    live "/concepts/:id/edit", ConceptLive.Edit, :edit

    live "/concepts/:concept_id/contents/:id", ContentLive.Show, :show
    live "/contents/new", ContentLive.New, :new
    live "/contents/:id/edit", ContentLive.Edit, :edit

    live "/crm", CrmLive.Index, :index
    live "/crm/:id", CrmLive.Show, :show
    live "/crm/:id/edit", CrmLive.Edit, :edit

    live "/subscriptions/:id/edit", SubscriptionLive.Edit, :edit
    live "/subscriptions/new", SubscriptionLive.New, :new

    live "/profile/:id", ProfileLive.Show, :show
    live "/profile/:id/edit", ProfileLive.Edit, :edit

    live "/youtubes/new", YoutubeLive.New, :new
    live "/youtubes/:id/edit", YoutubeLive.Edit, :edit

    live "/internet_images/new", InternetImageLive.New, :new
    live "/internet_images/:id/edit", InternetImageLiveLive.Edit, :edit

    live "/frames/new", FrameLive.New, :new
    live "/frames/:id/edit", FrameLive.Edit, :edit

    live "/video/new", VideoLive.New, :new

    live "/canvas", CanvasLive.Index, :index

    live "/books", BookLive.Index, :index

    live "/questions/new", QuestionLive.New, :new
    live "/questions/:id/edit", QuestionLive.Edit, :edit

    live "/quizzes/new", QuizLive.New, :new
    live "/quizzes/:id/edit", QuizLive.Edit, :edit
  end

  scope "/", TriviumWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm

    live "/", PageLive, :index
    live "/learn-more", LearnMoreLive, :index
    # live "/", TeaserLive, :index
  end

end
