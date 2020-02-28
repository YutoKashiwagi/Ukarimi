Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show]
  resources :questions do
    resources :answers, only: [:create, :destroy, :edit, :update]
    resources :best_answers, only: :update
  end
end
