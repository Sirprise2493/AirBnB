Rails.application.routes.draw do
  # / (Homepage root_path)
  root "pages#home"

  # /listings (index), /listings/new (new), /listings (POST) (create), /listings/:id (show)
  resources :listings, only: [:index, :new, :create]

  resources :listings, only: [:show] do
    resources :reviews, only: [:create]
    resources :bookings, only: [:create]
  end

  # /bookings/new (new), /bookings (POST) (create), /bookings/:id (show)
  resources :bookings, only: [:new, :create, :show]

  # /users/:id/profile (show in controller and special path user_profile_path)
  # get "users/:id/profile", to: "users#show", as: :user_profile
  resource :users, only: :show, as: :user_profile

  # Devise auth
  devise_for :users
end
