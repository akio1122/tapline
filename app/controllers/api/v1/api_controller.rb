class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def render_success(extra = {})
    render json: extra
  end

  def render_error(extra = nil)
    if extra.nil?
      render json: {}, status: :unprocessable_entity
    else
      render json: extra, status: :unprocessable_entity
    end
  end
end