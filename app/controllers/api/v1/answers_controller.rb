class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def create
    @question = Question.find(params[:question_id])
    respond_with @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
