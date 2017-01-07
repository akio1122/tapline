class AdviceSessionService

  attr_reader :session

  def initialize(session)
    @session = session.decorate
  end

  def create_session_with(customer)
    @session.assign_actors!(expert, customer)
    @session.assign_phone_number!

    expert_start_session_sms
    @session.save
    @session
  end

  def end_session
    if @session.status == :pending
      @session.end!
      end_session_sms_for_expert
    else
      @session.end!
      @session.charge!

      end_session_sms_for_expert
      end_session_sms_for_customer
    end
  end

  private

  def expert
    Expert.last
  end

  def expert_start_session_sms
    end_session_url = short_url_for(Rails.application.routes.url_helpers.end_by_link_advice_sessions_url(access_token: @session.access_token))
    message = "You have a new customer looking for advice. Reply back with your picture & name to start the conversation. Once the conversation ends, click here to end the session: #{end_session_url}"

    send_text(@session.expert.number, message)
  end

  def end_session_sms_for_expert
    message = "Your session has now ended."

    send_text(@session.expert.number, message)
  end

  def end_session_sms_for_customer
    edit_email_url = short_url_for(Rails.application.routes.url_helpers.customers_edit_email_url(session_token: @session.access_token, customer_token: @session.customer.access_token))
    message = "Your session with #{@session.expert.name} has ended. Click here to enter your email so we can send you a receipt: #{edit_email_url}"

    send_text(@session.customer.number, message)
  end

  def short_url_for(url)
    shortener_url = Shortener::ShortenedUrl.generate(url)
    Rails.application.routes.url_for(controller: :"shortener/shortened_urls", action: :show, id: shortener_url.unique_key, only_path: false)
  end

  def send_text(number, message)
    TWILIO_CLIENT.messages.create(
      from: @session.phone_number.number,
      to: number,
      body: message
    ) unless Rails.env.test?
  end
end
