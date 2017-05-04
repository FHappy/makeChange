Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # namespace :api, defaults:{format: 'json'} do
  #   resources :charges
  # end

  # post '/api/charges', 
  get '/api/charges' => "charges#index"

  post '/api/charges' => "charges#create"
  
  root to: 'client#index'
  get '*path', to: 'client#index'
end
