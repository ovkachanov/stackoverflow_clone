class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:destroy, :update, :best]
  before_action :set_question_answer, only: [:update, :best]

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
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
    end
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      flash[:notice] = 'Answer successfully edited'
    else
      flash[:alert] = 'Insufficient access rights'
    end
  end


  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer deleted.'
    else
      flash[:notice] = 'Insufficient access rights'
    end
  end

  def best
    @question = @answer.question
    if current_user.author_of?(@question)
      @answer.best
      flash[:notice] = 'You choose best answer'
    else
      flash[:alert] = 'Insufficient access rights'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def set_question_answer
     @question = @answer.question
  end

  def answer_params
   params.require(:answer).permit(:body)
  end
end
