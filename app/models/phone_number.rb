class PhoneNumber < ActiveRecord::Base

  phony_normalize :number, default_country_code: "US"

  class << self

    def from_twilio
      numbers = TWILIO_CLIENT.account.available_phone_numbers.get("US").local.list(in_region: "CA")

      number = numbers.first.phone_number
      TWILIO_CLIENT.account.incoming_phone_numbers.create(
        {
          phone_number: number,
        }.merge(callback_urls)
      )

      PhoneNumber.create(number: number)
    end

    private

    def callback_urls
      helpers = Rails.application.routes.url_helpers

      {
        voice_url: helpers.dispatch_receive_call_url,
        voice_method: "POST",
        status_callback: helpers.dispatch_update_call_url,
        status_callback_method: "POST",
        sms_url: helpers.dispatch_receive_message_url,
        sms_method: "GET"
      }
    end
  end
end
