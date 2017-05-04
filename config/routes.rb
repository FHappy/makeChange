Rails.application.routes.draw do
  devise_for :users
  
  get "api/users/current" => "api/users#current", as: "users_current"

  root to: 'client#index'
  get '*path', to: 'client#index'
end
