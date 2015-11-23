class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:destroy]

  def index
    @answers = Answer.all
  end

  def new
    @answer = Answer.new
  end

  def show
  end

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
    @answer.save
    flash[:notice] = 'Your answer successfully created.'
  end

  def destroy
    if @answer.user_id == current_user.id
      @answer.destroy
      flash[:notice] = 'Your answer deleted.'
    else
      flash[:notice] = 'Insufficient access rights'
    end
    redirect_to @answer.question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
   params.require(:answer).permit(:body)
  end
end
