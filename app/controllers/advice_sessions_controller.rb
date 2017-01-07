class AdviceSessionsController < ApplicationController

  before_action :authenticate_expert!, except: [:create, :end_by_link]
  before_action :check_session_presence, except: [:index]
  before_action :check_session_status, only: [:end, :end_by_link]

  def index
    sessions = current_expert.advice_sessions

    @pending_sessions = sessions.pending.decorate
    @current_sessions = sessions.active.decorate
    @past_sessions = sessions.inactive.decorate
  end

  def create
    customer = Customer.from_params(customer_params)

    session_service.create_session_with(customer)
  end

  def end
    session_service.end_session

    redirect_to advice_sessions_path
  end

  def end_by_link
    session_service.end_session

    render layout: "landing"
  end

  private

  def check_session_presence
    redirect_to root_path and return unless current_session
  end

  def check_session_status
    redirect_to root_path and return unless current_session.active
  end

  def session_service
    AdviceSessionService.new(current_session)
  end

  def current_session
    @current_session ||= begin
      if params[:id].present?
        AdviceSession.find(params[:id])
      elsif params[:access_token].present?
        AdviceSession.from_access_token(params[:access_token])
      else
        AdviceSession.create(stripe_card_token: customer_params[:stripe_token])
      end
    end
  end

  def customer_params
    params.require(:customer).permit(:phone_number, :name, :email, :stripe_token)
  end
end
