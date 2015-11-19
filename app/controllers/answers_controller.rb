class AnswersController < ApplicationController
  before_action :set_question, only: [:create, :destroy]
  before_action :set_answer, only: [:destroy]

  def new
    @answer = Answer.new
  end

  def show
  end

  def create
    @answer = @question.answers.create(answer_params.merge({ user: current_user }))
    if @answer.save
      flash[:notice] = 'Your answer successfully created.'
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    if @answer.user_id = current_user.id
      @answer.destroy
      flash[:notice] = 'Your answer deleted.'
    else
      flash[:notice] = 'Answer can not be deleted.'
    end
    redirect_to @question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
   params.require(:answer).permit(:body, :question_id)
  end
end
