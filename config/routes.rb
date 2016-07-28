Rails.application.routes.draw do
  post 'purchase' => 'purchases#create'

  root 'vehicles#index'

  get 'vehicles' => 'vehicles#index'

  get 'vehicle' => 'vehicles#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
