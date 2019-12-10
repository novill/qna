class SubscriptionsController < ApplicationController

  before_action :authenticate_user!

  authorize_resource

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    render :switch_subscription
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    render :switch_subscription
  end
end
