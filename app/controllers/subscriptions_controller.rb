class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:destroy]
  authorize_resource

  respond_to :js

  def create
    @question = Question.find(params[:question_id])
    respond_with @subscription = current_user.subscriptions.create(question: @question)
  end

  def destroy
    respond_with @subscription.destroy
  end

  private

  def set_subscription
    @subscription = current_user.subscriptions.find(params[:id])
  end
end

