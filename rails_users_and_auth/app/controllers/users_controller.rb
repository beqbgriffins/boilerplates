class UsersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  rescue_from ActiveRecord::RecordInvalid, with: :handle_invalid_record

  def create
    user = User.create!(user_params)
    token = encode_token(user_id: user.id)
    render json: {
      user: UserSerializer.new(user),
      token: token
    }, status: :created
  end

  def show
    render json: current_user, status: :ok
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def handle_invalid_record(e)
    render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
  end
end