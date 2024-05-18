Rails.application.routes.draw do
  devise_for :users
  resources :articles do
    member do
      post 'report'
    end
    resources :comments
  end
  root 'articles#index'
end
