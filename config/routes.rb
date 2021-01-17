Rails.application.routes.draw do
  resources :games do
    collection do
      post :search
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
