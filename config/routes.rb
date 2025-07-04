Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "top_pages#top"

  # user profile
  get "users/show", to: "users#show"
  get "users/edit", to: "users#edit"

  # homes
  get "/homes/theme_options", to: "homes#theme_options", as: "homes_theme_options"
  get "/homes", to: "homes#index"

  # chat_session
  get "/chats", to: "chats#index"
  post "/chats", to: "chats#create"
  get "/chats/new", to: "chats#new"

  # score
  get "scores", to: "scores#show"
  get "scores/index", to: "scores#index"

  # get to rule and policy
  get "/rule", to: "top_pages#rule", as: "rule"
  get "/policy", to: "top_pages#policy", as: "policy"
end
