class RatingsController < ApplicationController

  before_action :find_advice_session
  before_action :check_rating_existence

  def new
    render layout: "landing"
  end

  def create
    Rating.create(
      advice_session_id: @advice_session.id,
      expert_id: @advice_session.expert_actor.reference_id,
      value: params[:value]
    )
  end

  private

  def find_advice_session
    @advice_session = AdviceSession.from_access_token(params[:access_token])

    redirect_to root_path and return unless @advice_session
  end

  def check_rating_existence
    redirect_to root_path and return if @advice_session.rating.present?
  end
end
