class CommentsController < ApplicationController
  before_action :authenticate_user!, :find_resource

  # after_action :publish_comment

  def create
    @comment = @resource.comments.create(body:params[:body], user: current_user)
    # render json: params
  end

  private

  def find_resource
    @resource = ( params[:answer_id] ? Answer.find(params[:answer_id]) : Question.find(params[:question_id]))
  end

  def publish_comment
    return if @comment.errors.any?
    question_id = @resource.is_a?(Question) ? @resource.id : @resource.question.id
    ActionCable.server.broadcast("comments_question_#{question_id}", comment: @comment)
  end
end
