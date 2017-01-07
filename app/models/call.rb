class Call < ActiveRecord::Base

  PRICE_IN_CENTS_PER_SECOND = 5

  belongs_to :advice_session, counter_cache: true

  def price_in_cents
    return 0 unless dial_call_duration

    dial_call_duration.to_i * PRICE_IN_CENTS_PER_SECOND
  end

  class << self

    def from_twilio(params = {})
      mapped_params = {
        advice_session_id: params[:advice_session_id],

        account_sid: params[:AccountSid],
        to_zip: params[:ToZip],
        from_state: params[:FromState],
        called: params[:Called],
        from_country: params[:FromCountry],
        caller_country: params[:CallerCountry],
        called_zip: params[:CalledZip],
        direction: params[:Direction],
        from_city: params[:FromCity],
        called_country: params[:CalledCountry],
        caller_state: params[:CallerState],
        call_sid: params[:CallSid],
        called_state: params[:CalledState],
        from: params[:From],
        caller_zip: params[:CallerZip],
        from_zip: params[:FromZip],
        call_status: params[:CallStatus],
        to_city: params[:ToCity],
        to_state: params[:ToState],
        to: params[:To],
        to_country: params[:ToCountry],
        caller_city: params[:CallerCity],
        api_version: params[:ApiVersion],
        caller: params[:Caller],
        called_city: params[:CalledCity]
      }

      create(mapped_params)
    end

    def update_from_twilio(params = {})
      return unless params[:DialCallSid]

      mapped_params = {
        dial_call_sid: params[:DialCallSid],
        dial_call_duration: params[:DialCallDuration],
        dial_call_status: params[:DialCallStatus]
      }

      call = find_by(call_sid: params[:CallSid])
      return unless call

      call.update_attributes(mapped_params)
    end
  end
end
