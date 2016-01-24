class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource class: Question

  def index
    respond_with Question.all, each_serializer: QuestionsSerializer
  end
end
