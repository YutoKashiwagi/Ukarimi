Rails.application.routes.draw do
  root 'home#home'

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

  resources :questions, shallow: true do
    resources :comments, only: [:create, :destroy], module: :questions
    resources :likes, only: [:create, :destroy], module: :questions
    resources :answers, only: [:create, :destroy, :edit, :update] do
      resources :comments, only: [:create, :destroy], module: :answers
      resources :likes, only: [:create, :destroy], module: :answers
    end
  end

  namespace :category, shallow: true do
    resources :categories, only: [:index, :show]
  end

  # ユーザーがカテゴリーをフォローする時のルーティング。delete時、relationshipのidを取らない形にするため手動のルーティングに。
  post '/follow_category', to: "follow_categories#create"
  delete '/unfollow_category', to: "follow_categories#destroy"

  resources :best_answers, only: :create

  resources :searches, only: :index
end
