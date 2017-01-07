module Api::V1
  class Api::V1::AdviceSessionsController < ApiController
    include ApipieDescriptions

    resource_description do
      name 'Sessions management'
      short 'Request or terminate session'
      formats ['json']
    end

    apipie_advice_sessions_create
    def create
      customer = Customer.from_params(customer_params)
      unless customer.valid? && current_session.valid?
        error = {}
        error.merge!(customer.errors).merge!(current_session.errors)
        render_error(error) and return
      end

      session = session_service.create_session_with(customer)
      render_success({access_token: session.access_token})
    end

    private

    def session_service
      AdviceSessionService.new(current_session)
    end

    def current_session
      @current_session ||= begin
        if params[:access_token].present?
          AdviceSession.from_access_token(params[:access_token])
        else
          AdviceSession.create(stripe_card_token: params[:stripe_card_token])
        end
      end
    end

    def customer_params
      params.require(:customer).permit(:phone_number, :name, :email)
    end
  end
end
