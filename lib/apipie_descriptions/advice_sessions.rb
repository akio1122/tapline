module ApipieDescriptions::AdviceSessions
  def apipie_advice_sessions_create
    api :POST, '/request-session', 'Request session'
    param :customer, Hash, desc: 'Customer Info', required: true do
      param :name, String, desc: 'Name of customer', required: true
      param :phone_number, String, desc: 'Phone number of customer', required: true
      param :email, String, desc: 'Email of customer', required: false
    end
    param :stripe_card_token, String, desc: 'Stripe card token for charge', required: true

    description 'Request session with customer information and stripe token'

    apipie_clear(__method__)
  end
end