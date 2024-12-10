Rails.application.routes.draw do
  root to: "pages#home"

  # USER PAGES
  devise_for :users
  get '/:username/activities', to: 'activities#my_activities', as: :my_activities
  get '/:username/groups', to: 'group_users#index', as: :my_groups
  get '/:username/profile', to: 'users#show'

  # ACTIVITY PAGES
  resources :activities do
    resources :bookings, only: [:index] do
    end
  end
  post "activities/:id/book", to: "bookings#create", as: :book_activity


  # BOOKINGS PAGES
  resources :bookings do
    collection do
      get :booking_requests
    end
    member do
      patch :accept
      patch :decline
    end
  end

  # GROUPS/GROUP_USERS PAGES
  resources :groups do
    # resources :group_posts, only: [:create, :destroy]
    resources :group_user, only: [:destroy]

    resources :group_posts do
      resources :group_comments, only: [:create, :destroy]
    end
  end
  post "groups/:id/join", to: "group_users#create", as: :join_group
  delete "groups/:id/leave", to: "group_users#destroy", as: :leave_group

end
