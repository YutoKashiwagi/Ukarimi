Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show]
  resources :questions, only: [:index, :show, :create, :destroy] do
    resources :answers, only: [:create, :destroy]
  end
end
