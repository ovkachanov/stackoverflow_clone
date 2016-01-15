class VotesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_votable

  respond_to :json

  authorize_resource

  def up
    if vote_empty
      vote_it 1
    else
      render nothing: true, status: :forbidden
    end
  end

  def down
    if vote_empty
      vote_it -1
    else
      render nothing: true, status: :forbidden
    end
  end

  def unvote
    @vote = Vote.find_by(user_id: current_user.id, votable: @votable)
    authorize! :unvote, @vote
    @vote.destroy
    render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
  end

  private

  def vote_it(rating)
    @vote = Vote.new(rating: rating, user_id: current_user.id, votable: @votable)
    authorize! params[:action].to_sym, @vote
    if @vote.save
      render json: { count_votes: @vote.votable.count_votes, votable_type: @vote.votable_type, votable_id: @vote.votable_id }
    end
  end

  def vote_empty
    nil == Vote.find_by(user_id: current_user.id, votable: @votable)
  end

  def load_votable
    @votable =  params[:question_id] ? Question.find(params[:question_id]) : Answer.find(params[:answer_id])
  end
end
