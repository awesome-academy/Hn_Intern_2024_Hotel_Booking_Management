require "sidekiq/web"
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/signin", to: "sessions#new"
    post "/signin", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :rooms, only: %i(index show) do
      get :check_available, on: :member
      post :index, on: :collection
    end

    post "bookings/:id", to: "bookings#show", as: "booking"
    resources :bookings, except: :show

    resource :reviews, only: %i(create update)

    namespace :admin do
      get "dashboard", to: "dashboard#index"
      resources "bookings", only: %i(index show update)
    end

    resources "account_activations", only: :edit
  end
end
