class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:update, :destroy, :best]

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
    respond_to do |format|

    if @answer.save
      format.js do
       PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
       render nothing: true
        end
      else
        format.json { render json: @answer.errors.full_messages, status: :unprocessable_entity }
        format.js
      end
    end
  end


  def update
    @question = @answer.question
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
    if current_user.author_of?(@answer.question)
      @answer.best
      flash[:notice] = 'You choose best answer'
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
   params.require(:answer).permit(:body, attachments_attributes: [:file] )
  end
end
