Rails.application.routes.draw do
  get "scores/show"
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords"
  }
  resources :tasks
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

  # homes
  get "/homes", to: "homes#index"
  get "/homes/theme_options", to: "homes#theme_options", as: "homes_theme_options"

  # chat_session
  get "/chats", to: "chats#index"
  post "/chats", to: "chats#create"
  get "/chats/new", to: "chats#new"

  # score
  get "scores", to: "scores#show"
  get "scores/index", to: "scores#index"
end
