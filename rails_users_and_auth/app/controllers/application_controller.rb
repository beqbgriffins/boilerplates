class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, jwt_secret)
  end

  def decoded_token
    if auth_header
      token = auth_header
      begin
        JWT.decode(token, jwt_secret, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    @current_user ||= if decoded_token
                        user_id = decoded_token[0]['user_id']
                        User.find_by(id: user_id)
                      end
  end

  def authorized
    unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end

  private

  def auth_header
    request.headers['Authorization']
  end

  def jwt_secret
    Rails.application.credentials.jwt_secret
  end
end
