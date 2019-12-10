class Api::V1::AnswersController < Api::V1::BaseController

  before_action :load_question, only: [:create]
  before_action :load_answer, only: [:show, :update, :destroy]

  authorize_resource


  def show
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      render json: @answer, status: :created
    else
      render json: @answer.errors, status: :unprocessable_entity
    end
  end

  def update
    head :not_found and return unless @answer

    if @answer.update(answer_params)
      render json: @answer, status: :accepted
    else
      render json: @answer.errors, status: :unprocessable_entity
    end

  end

  def destroy
    head :not_found and return unless @answer
    if @answer.destroy
      render json: @answer, status: :accepted
    else
      render json: @answer.errors, status: :unprocessable_entity
    end

  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end