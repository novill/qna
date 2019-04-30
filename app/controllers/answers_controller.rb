class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, only: %i[update destroy set_as_best]

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

  def answer_params
    params.require(:answer).permit(:body)
  end

  def load_answer
    @answer = Answer.find(params[:id])
  end
end
