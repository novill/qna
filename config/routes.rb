Rails.application.routes.draw do
  devise_for :users
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
    resources :comments, only: [:create]
    resources :answers, concerns: [:voted], only: [:new, :create, :destroy, :update], shallow: true do
      resources :comments, only: [:create]
      post :set_as_best, on: :member
    end
  end

  mount ActionCable.server => "/cable"
end
