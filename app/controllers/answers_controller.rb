class AnswersController < ApplicationController
  authorize_resource

  include Voted

  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy set_as_best]

  after_action :publish_answer, only: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.create(answer_params.merge(user: current_user))
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def update
    if current_user&.author_of?(@answer)
      @answer.update(answer_params)
    end
    @question = @answer.question
  end

  def set_as_best
    @answer.set_as_best if current_user&.author_of?(@answer.question)
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
        "answers_question_#{@question.id}",
        answer: @answer,
        answer_id: @answer.id
    # ,
    #     links: @answer.links,
    #     files: @answer.files

    )
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
