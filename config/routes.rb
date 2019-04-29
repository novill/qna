Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :update], shallow: true
  end
end
