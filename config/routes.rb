Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show]
  resources :questions, only: [:index, :show, :create, :destroy, :edit, :update] do
    resources :answers, only: [:create, :destroy, :edit, :update]
  end
  resources :best_answers, only: [:create, :destroy]
end
