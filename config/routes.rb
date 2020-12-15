Rails.application.routes.draw do
  resources :games
  resources :communities, only: [:index, :show, :update, :destroy] do
    collection do
      post :set_active
      post :assign_role
      post :unassign_role
      post :join
    end
    resources :events do
      collection do
        post :join
        post :leave
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
