Rails.application.routes.draw do
  root to: 'urls#index'

  resources :urls, only: [:index, :create]

  get '/stat/:short_url', to: 'urls#stat'
  get '/short/:short_url', to: 'urls#short'
  get '/:short_url', to: 'urls#redirect'
end
