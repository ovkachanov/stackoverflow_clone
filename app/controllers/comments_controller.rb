class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :load_commentable

  respond_to :js

  authorize_resource

  def create
    respond_with(@comment = current_user.comments.create(commentable: @commentable, comment_body: comment_params[:comment_body]))
  end

  private

  def load_commentable
    @commentable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end

  def comment_params
    params.require(:comment).permit(:comment_body)
  end
end
