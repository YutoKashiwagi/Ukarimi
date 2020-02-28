Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show], shallow: true do
    resources :stocks, only: [:index, :create, :destroy]
    resources :followees, only: [:index, :create, :destroy]
    resources :followers, only: [:index]
  end
  resources :questions do
    resources :answers, only: [:create, :destroy, :edit, :update]
    resources :best_answers, only: :update
  end
end
