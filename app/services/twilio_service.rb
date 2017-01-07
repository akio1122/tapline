class TwilioService

  NO_SESSION_TEXT = "Sorry, you have no open sessions with a Smooth expert"

  def initialize(options = {})
    @options = options
  end

  def process_message
    send_no_session_sms and return unless advice_session

    forward_sms

    advice_session.count +=1
    advice_session.save
  end

  def create_call
    return no_session_call_response unless advice_session

    options = @options.merge(advice_session_id: advice_session.id)
    Call.from_twilio(options)

    success_call_response
  end

  def update_call
    Call.update_from_twilio(@options)

    update_call_response
  end

  def forward_to_number
    (advice_session.actor_numbers - [normalized_phone(@options[:From])]).first
  end

  private

  def success_call_response
    update_call_path = Rails.application.routes.url_helpers.dispatch_update_call_path

    Twilio::TwiML::Response.new do |r|
      r.Dial action: update_call_path, callerId: advice_session.phone_number.number do |d|
        d.Number forward_to_number
      end
    end.text
  end

  def no_session_call_response
    Twilio::TwiML::Response.new do |r|
      r.Say NO_SESSION_TEXT, voice: "alice"
      r.Hangup
    end.text
  end

  def update_call_response
    Twilio::TwiML::Response.new.text
  end

  def send_no_session_sms
    TWILIO_CLIENT.messages.create(
      from: normalized_phone(@options[:To]),
      to: normalized_phone(@options[:From]),
      body: NO_SESSION_TEXT
    )
  end

  def forward_sms
    TWILIO_CLIENT.messages.create(message_options)
  end

  def message_options
    options = {
      from: advice_session.phone_number.number,
      to: forward_to_number,
      body: @options[:Body]
    }
    options.merge!(media_url: media_url) if media_url
    options
  end

  def media_url
    @media_url ||= @options[:NumMedia].to_i.times.map { |i| @options["MediaUrl#{i}"] }.try(:first)
  end

  def advice_session
    @advice_session ||= begin
      phone_number = current_phone_number
      return unless phone_number

      AdviceSession.find_by(phone_number_id: phone_number.id, active: true)
    end
  end

  def current_phone_number
    PhoneNumber.find_by(number: normalized_phone(@options[:To]))
  end

  def normalized_phone(number)
    PhonyRails.normalize_number(number, country_code: "US")
  end
end