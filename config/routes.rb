Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"

    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/signin", to: "sessions#new"
    post "/signin", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    resources :rooms, only: %i(index show) do
      get :check_available, on: :member
    end

    get "booking/:id", to: "bookings#new", as: "new_booking"
    post "bookings/:id", to: "bookings#show", as: "booking"
    resources :bookings, except: %i(show new)

    namespace :admin do
      get "dashboard", to: "dashboard#index"
    end
  end
end
