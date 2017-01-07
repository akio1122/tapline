module ApipieDescriptions::Ratings
  def apipie_ratings_create
    api :POST, '/v1/rate-session', 'Rate session'
    param :access_token, String, 'Session access token', required: true
    param :value, String, 'Rate value, default: 1'
    description 'Request session with customer information and stripe token'

    apipie_clear(__method__)
  end
end