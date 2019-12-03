class Api::V1::AnswersController < Api::V1::BaseController

  authorize_resource


  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end
end