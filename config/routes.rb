Rails.application.routes.draw do
  root 'welcome#index'

  get 'auth/github/callback' => 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'signout', to: 'sessions#destroy', as: 'signout'

  resources :stars, only: %i(index) do
    post 'tag/:slug' => 'star_tags#create'
    delete 'tag/:slug' => 'star_tags#destroy'
  end
end
