Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'questions#index'
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  resources :questions do
    resources :answers, only: [:new, :create, :destroy, :update], shallow: true do
      post :set_as_best, on: :member
    end
  end
end
