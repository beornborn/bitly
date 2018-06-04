Rails.application.routes.draw do
  root to: 'urls#index'
  get "/:short_url", to: "urls#redirect"
  get '/urls', to: redirect('/')

  resources :urls, only: [:create, :show] do
    get :statistics, on: :member
  end
end
