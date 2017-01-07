class DispatchController < ApplicationController

  skip_before_filter :verify_authenticity_token

  def receive_message
    twilio_service.process_message

    render nothing: true, status: :ok
  end

  def receive_call
    render text: twilio_service.create_call, content_type: "application/xml"
  end

  def update_call
    render text: twilio_service.update_call, content_type: "application/xml"
  end

  private

  def twilio_service
    @twilio_service ||= TwilioService.new(params)
  end
end
