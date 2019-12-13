require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'

  concern :voted do
    member do
      post :upvote
      post :downvote
      post :vote_back
    end
  end

  concern :commentable do
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  
  resources :questions, concerns: [:voted] do
    resources :subscriptions, only: [:create, :destroy], shallow: true
    resources :comments, only: [:create]
    resources :answers, concerns: [:voted], only: [:new, :create, :destroy, :update], shallow: true do
      resources :comments, only: [:create]
      post :set_as_best, on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [] do
        get :me, on: :collection
        get :others, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy ] do
        resources :answers, only: [:show, :create, :update, :destroy ], shallow: true
        get :answers, on: :member
      end
    end
  end

  get '/search', to: 'search#show', as: :search

  mount ActionCable.server => "/cable"
end
