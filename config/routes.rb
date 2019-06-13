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

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :rewards, only: :index
  
  resources :questions, concerns: [:voted] do
    resources :answers, concerns: [:voted], only: [:new, :create, :destroy, :update], shallow: true do
      post :set_as_best, on: :member
    end
  end
end
