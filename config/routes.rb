Rails.application.routes.draw do
  root 'welcome#index'

  get 'auth/github/callback' => 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'signout', to: 'sessions#destroy', as: 'signout'

  resources :stars, only: %i(index) do
    post 'tag/:slug' => 'star_tags#create'
    delete 'tag/:slug' => 'star_tags#destroy'
  end

  get 'stars/tagged/*tags' => 'stars#index', as: 'tagged_stars'
  get 'stars/untagged' => 'stars#index', untagged: true, as: 'untagged_stars'

  resources :tags, only: %i(index) do
    get :suggest, on: :collection
  end
end
