require 'test_helper'

module Api::V1
  class RatingsControllerTest < ActionController::TestCase
    test 'rate session without advice session access token' do
      post :create, format: :json
      assert_response :unprocessable_entity
      res = JSON.parse(response.body)
      assert_equal res['error'], 'No access token.'
    end

    test 'cannot rate session already rated' do
      post :create, format: :json, access_token: AdviceSession.first.access_token
      assert_response :unprocessable_entity
      res = JSON.parse(response.body)
      assert_equal res['error'], 'You already rated this session.'
    end

    test 'can rate session' do
      AdviceSession.first.rating.destroy
      post :create, format: :json, access_token: AdviceSession.first.access_token
      assert_response :success
    end
  end
end
