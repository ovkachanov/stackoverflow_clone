class SearchController < ApplicationController
  skip_authorization_check

  def index
    authorize! :read, @results
    respond_with(@results = Search.query(params[:query], params[:condition]))
  end
end
