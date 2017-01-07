module Api::V1
  class RatingsController < ApiController
    include ApipieDescriptions
    before_action :find_advice_session
    before_action :check_rating_existence

    resource_description do
      name 'Session rating'
      short 'Rate session'
      formats ['json']
    end

    apipie_ratings_create
    def create
      @rating = @advice_session.build_rating(
        expert_id: @advice_session.expert_actor.reference_id,
        value: params[:value] || 1
      )
      @rating.save ? render_success : render_error(@rating)
    end

    private

    def find_advice_session
      @advice_session = AdviceSession.from_access_token(params[:access_token])
      render_error({error: 'No access token.'}) and return unless @advice_session
    end

    def check_rating_existence
      render_error({error: 'You already rated this session.'}) and return if @advice_session.rating.present?
    end
  end
end
