Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  root to: 'client#index'
  get '*path', to: 'client#index'
end
