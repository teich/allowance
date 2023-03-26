Rails.application.routes.draw do
  get 'settings/edit'
  get 'settings/update'
  get 'allowance_events/create'
  get 'dashboard/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'dashboard#index'
  resource :settings, only: [:edit, :update]
  resources :allowance_events, only: [:create]
end
