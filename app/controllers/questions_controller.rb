class QuestionsController < ApplicationController
  include Voted
  protect_from_forgery except: :add_another_answer

  before_action :authenticate_user!, except: [:index, :show, :add_another_answer]
  before_action :load_question, only: [:show, :update, :destroy, :comment]

  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.new
  end

  def new
    @question = Question.new
    @question.links.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user&.author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully deleted.'
    end
    redirect_to questions_path
  end

  def update
    @question.update(question_params) if current_user&.author_of?(@question)
  end

  def add_another_answer
    @answer = Answer.find(params[:answer_id])
    render partial: 'answers/answer', locals: {answer: @answer}
  end

  def comment
    comment = @question.comments.create(body: params[:body], user: current_user)

    render json: comment
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      question: @question
      # ApplicationController.render(
      #   partial: 'questions/question',
      #   locals: { question: @question }
      # )
    )
  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
    gon.question_id = @question.id
    gon.question_user_id = @question.user_id
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url], reward_attributes: [:title, :image ])
  end
end
