Rails.application.routes.draw do
  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show], shallow: true do
    resources :posts do
      resources :comments, only: [:create, :destroy], module: :posts
      resources :likes, only: [:create, :destroy], module: :posts
    end
    resources :stocks, only: [:index, :create, :destroy]
    resources :followees, only: [:index, :create, :destroy]
    resources :followers, only: [:index]
  end

  resources :questions do
    resources :comments, only: [:create, :destroy], module: :questions
    resources :likes, only: [:create, :destroy], module: :questions
    resources :answers, only: [:create, :destroy, :edit, :update] do
      resources :comments, only: [:create, :destroy], module: :answers
      resources :likes, only: [:create, :destroy], module: :answers
    end
    resources :best_answers, only: :update
  end

  namespace :category do
    resources :categories, only: [:index, :show] do
      resources :follow_categories, only: [:create, :destroy]
    end
  end
end
