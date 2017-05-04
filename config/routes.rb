Rails.application.routes.draw do
  devise_for :users

  
  get "api/users/current" => "api/users#current", as: "users_current"
  get "api/charities" => "api/charities#index", as: "charities_index"

  namespace :api do
    resources :charges, only: [:index, :create]
  end
  
  root to: 'client#index'
  get '*path', to: 'client#index'
end
