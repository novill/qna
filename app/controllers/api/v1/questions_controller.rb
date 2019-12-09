class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :load_question, only: [:show, :answers, :update, :destroy]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question
  end

  def answers
    @answers = Question.find(params[:id]).answers
    render json: @answers
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def update
    head :not_found and return unless @question

    if @question.update(question_params)
      render json: @question, status: :accepted
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  def destroy
    head :not_found and return unless @question
    if @question.delete
      render json: @question, status: :accepted
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def load_question
    @question = Question.find(params[:id])
  end
end
