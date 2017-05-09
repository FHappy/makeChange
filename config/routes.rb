Rails.application.routes.draw do
  devise_for :users

  mount ActionCable.server => '/cable'

  
  get "api/users/current" => "api/users#current", as: "users_current"
  get "api/charities" => "api/charities#index", as: "charities_index"
  get "api/charities/:ein" => "api/charities#show", as: "charities_show"
  get "api/charities/search/:query/:page" => "api/charities#search", as: "charities_search"
  get "api/charities/search_category/:query/:page" => "api/charities#search_category", as: "charities_search_category"
  get "api/charities/search_location/:query/:page" => "api/charities#search_location", as: "charities_search_location"
  post "api/charities" => "api/charities#donate", as: "charities_donate"
  post "api/comments" => "api/comments#create", as: "comments_create"
  delete "api/comments/:id" => "api/comments#destroy", as: "comments_destroy"
  patch "api/comments" => "api/comments#update", as: "comments_update"

  namespace :api do
    resources :charges, only: [:index, :create]
  end
  
  root to: 'client#index'
  get '*path', to: 'client#index'
end
