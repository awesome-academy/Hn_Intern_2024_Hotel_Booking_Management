require "sidekiq/web"
Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq"
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"
    devise_for :users, controllers: {
      registrations: "users/registrations"
    }

    resources :rooms, only: %i(index show) do
      get :check_available, on: :member
      post :index, on: :collection
    end

    post "bookings/:id", to: "bookings#show", as: "booking"
    resources :bookings, except: %i(show edit update)

    resource :reviews, only: %i(create update)

    namespace :admin do
      get "dashboard", to: "dashboard#index"
      resources "bookings", only: %i(index show update)
      resources "users", only: %i(index show)
      post "lock/:id", to: "users#lock_user", as: "lock_user"
      post "unlock/:id", to: "users#unlock_user", as: "unlock_user"
      resources "rooms", only: %i(index show update new create) do
        member do
          post :active_room
          post :inactive_room
        end
      end
      resources "room_types", only: %i(index update show)
      post "active_room_type/:id", to: "room_types#active", as: "active_room_type"
      post "inactive_room_type/:id", to: "room_types#inactive", as: "inactive_room_type"
      delete "remove_image/:id", to: "room_types#remove_image", as: "remove_image"
    end
    delete "remove_profile_image/:id", to: "application#remove_profile_image", as: "remove_profile_image"
  end

  namespace :api do
    namespace :v1 do
      post "authenticate", to: "authentication#create"
      resources :rooms, only: :index
      resources :bookings, only: %i(index show create)
    end
  end
end
