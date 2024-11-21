Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :activities do
    resources :bookings, only: [:create]
    resources :bookings, only: [:index] do
      collection do
        get :request  # Show pending bookings for a specific activity
      end
    end
  end

  resources :groups do
    resources :group_users, only: [:create]
  end

  get "my_activities", to: "activities#my_activities"

  resources :bookings do
    collection do
      get :booking_requests

    end
    member do
      patch :accept
      patch :decline
    end
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
