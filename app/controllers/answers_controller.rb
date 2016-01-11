class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :destroy, :best]
  before_action :set_question_answer, only: [:update]


  respond_to :js

  def create
    respond_with (@answer = @question.answers.create(answer_params.merge({ user: current_user })))
  end


  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with @answer
  end


  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def best
    respond_with(@answer.best) if current_user.author_of?(@answer.question)
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
   params.require(:answer).permit(:body, attachments_attributes: [:file] )
  end
end
