Rails.application.routes.draw do
  mount API::Base, at: "/"
  resources :games do
    collection do
      get :search
      post :get_igdb_game
    end
  end
  resources :communities, only: [:index, :show, :update, :destroy] do
    collection do
      post :set_active
      post :assign_role
      post :unassign_role
      post :join
      post :leave
      post :fetch
    end
    resources :events do
      member do
        post :send_poll
      end
      collection do
        post :fetch
        post :join
        post :leave
        #post :send_poll
        get :public_join
        post :join_team
        post :update_team
        post :assign_captain
      end
    end  
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations'
  }

  # mount ActionCable.server => '/cable'
  root to: "home#index"
  # resources :channels
  # namespace :api, defaults: { format: :json } do
  #   namespace :v1 do
      
  #   end
  # end
end
