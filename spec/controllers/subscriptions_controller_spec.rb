# frozen_string_literal: true
require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:subscription) { create(:subscription, user_id: user.id) }

  before { sign_in(user) }

  describe 'POST #create' do
    it 'saves the new subscription' do
      expect{ post :create, params: { question_id: question.id }, format: :js }.to change(user.subscriptions, :count).by(1)
    end

    it 'does not save new subscription if exists' do
      question.subscriptions.create(user_id: user.id)
      expect{ post :create, params: { question_id: question.id }, format: :js }.not_to change(Subscription, :count)
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes subscription' do
      subscription
      expect { delete :destroy, params: { id: subscription.id }, format: :js }.to change(Subscription, :count).by(-1)
    end
  end
end