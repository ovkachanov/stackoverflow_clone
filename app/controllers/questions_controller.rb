class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, only: [:show, :edit, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action  :publish_question, only: [:create]

  respond_to :js, only: :update

  def index
    respond_with(@questions = Question.all)
  end

  def show
  end

  def new
   respond_with(@question = Question.new)
  end

  def edit
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with @question
  end

  def destroy
    respond_with @question.destroy if current_user.author_of?(@question)
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file, :id, :_delete])
  end

  def build_answer
    @answer = @question.answers.build
  end

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end
end
