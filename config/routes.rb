Rails.application.routes.draw do
  get 'transactions/index'
  get 'transactions/create'
  get 'settings/edit'
  get 'settings/update'
  get 'allowance_events/create'
  get 'dashboard/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'dashboard#index'
  resource :settings, only: [:edit, :update] do 
    post 'run_weekly_allowance', on: :collection
  end
  resources :allowance_events, only: [:create]
  resources :transactions, only: [:index, :create, :destroy]

  get '/auth/google_oauth2/callback', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy', as: 'sign_out'

end
