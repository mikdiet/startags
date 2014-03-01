Rails.application.routes.draw do
  root 'welcome#index'

  get 'auth/github/callback' => 'sessions#create'
  get 'auth/failure', to: redirect('/')
  delete 'signout', to: 'sessions#destroy', as: 'signout'
end
