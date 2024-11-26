Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get '/:username/activities', to: 'activities#my_activities', as: :my_activities
  get '/activities', to: 'activities#index', as: :default_activities

  get '/:username/groups', to: 'group_users#index', as: :my_groups
  get '/groups', to: 'group_users#index', as: :default_groups

  resources :activities do
    resources :bookings, only: [:index] do
    end
  end
  # get "my_activities", to: "activities#my_activities"
  post "activities/:id/book", to: "bookings#create", as: :book_activity


  resources :bookings do
    collection do
      get :booking_requests
    end
    member do
      patch :accept
      patch :decline
    end
  end

  resources :groups do
    resources :group_comments, only: [:create, :destroy]
    resources :group_user, only: [:destroy]
  end
  post "groups/:id/join", to: "group_users#create", as: :join_group
  delete "groups/:id/leave", to: "group_users#destroy", as: :leave_group

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
