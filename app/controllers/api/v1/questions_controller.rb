class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def answers
    @answers = Question.find(params[:id]).answers
    render json: @answers
  end
end