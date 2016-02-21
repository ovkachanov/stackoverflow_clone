class SearchController < ApplicationController
  before_action :load_params

  skip_authorization_check

  def index
    @result = ThinkingSphinx.search(@query)
  end

  private

  def load_params
    @query = params[:query]
  end
end
