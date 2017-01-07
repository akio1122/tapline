require 'test_helper'

module Api::V1
  class AdviceSessionsControllerTest < ActionController::TestCase
    test 'request session will all blank params' do
      post :create, format: :json, stripe_card_token: '', customer: {name: '', phone_number: '', email: ''}
      assert_response :unprocessable_entity
      res = JSON.parse(response.body)
      assert_equal res['stripe_card_token'], ["can't be blank"]
      assert_equal res['name'], ["can't be blank"]
      assert_equal res['number'], ["invalid phone number"]
    end

    test 'request session with empty stripe token' do
      post :create, format: :json, stripe_card_token: '', customer: {name: 'Test User', phone_number: '+15005550006', email: ''}
      assert_response :unprocessable_entity
      res = JSON.parse(response.body)
      assert_equal res['stripe_card_token'], ["can't be blank"]
    end

    test 'request session with invalid phone number' do
      post :create, format: :json, stripe_card_token: 'test stripe token', customer: {name: 'Test User', phone_number: 'invalid phone number', email: ''}
      assert_response :unprocessable_entity
      res = JSON.parse(response.body)
      assert_equal res['number'], ["invalid phone number"]
    end

    test 'it success to get session token' do
      post :create, format: :json, stripe_card_token: 'test stripe token', customer: {name: 'Test User', phone_number: '+15005550006', email: 'test@example.com'}
      assert_response :success
      res = JSON.parse(response.body)
      assert_equal res['session_token'], AdviceSession.last.access_token
    end
  end
end
