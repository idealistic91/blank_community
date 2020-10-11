Rails.application.routes.draw do
  resources :games
  resources :events do
    collection do
      post :join
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }

  # mount ActionCable.server => '/cable'
  root to: "home#index"
  #get to: "home#connect_with_discord"
  # resources :channels
  # namespace :api, defaults: { format: :json } do
  #   namespace :v1 do
      
  #   end
  # end
end
