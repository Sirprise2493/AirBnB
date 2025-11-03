Rails.application.routes.draw do
  # / (Homepage root_path)
  root "pages#home"

  # /listings (index), /listings/new (new), /listings (POST) (create), /listings/:id (show)
  resources :listings, only: [:index, :new, :create]

  resources :listings, only: [:show, :destroy] do
    resources :reviews, only: [:create]
    resources :bookings, only: [:create]
  end

  # /bookings/new (new), /bookings (POST) (create), /bookings/:id (show)
  resources :bookings, only: [:new, :create, :show, :destroy] do
    member do
      patch :accept
      patch :reject
    end
  end
  
  # New addition
  # ----------------
  # /users/:id/profile (show in controller and special path user_profile_path)
  # NOTE: using explicit routes to avoid conflicts with Devise and to allow clean /profile URLs
  get "users", to: "users#show", as: :user_profile

  # ----------------
  # End new addition 

  # Devise auth
  devise_for :users, controllers: { registrations: 'users/registrations' }
end
