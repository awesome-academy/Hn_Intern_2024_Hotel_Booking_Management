Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root "static_pages#home"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    resources :rooms, only: %i(index show) do
      get :check_available, on: :member
    end

    get "/signin", to: "sessions#new"
    post "/signin", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"

    get "bookings/:id", to: "bookings#new", as: "new_booking"
    resources :bookings, except: :new
  end
end
