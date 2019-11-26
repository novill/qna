class CommentsController < ApplicationController


  before_action :authenticate_user!, :find_resource

  after_action :publish_comment, only: [:create]

  authorize_resource

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
    ActionCable.server.broadcast(
      "comments_question_#{question_id}",
      comment_resource_id: "#{@resource.class.to_s.downcase}-#{@resource.id}",
      comment_user_id: @comment.user_id,
      comment_html:
        ApplicationController.render(
          partial: 'comments/comment',
          locals: { comment: @comment }
      )


    )
  end
end
