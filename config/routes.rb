Rails.application.routes.draw do
  get 'questions/index'

  get 'questions/show'

  root 'static_pages#home'

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :users, only: [:show]
end
