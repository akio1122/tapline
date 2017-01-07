account_sid = ENV['TWILIO_ACCOUNT_SID']
auth_token = ENV['TWILIO_AUTHTOKEN']

# set up a client to talk to the Twilio REST API
TWILIO_CLIENT = Twilio::REST::Client.new account_sid, auth_token