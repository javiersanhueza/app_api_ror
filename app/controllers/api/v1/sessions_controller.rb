class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  before_action :valid_token, only: :destroy
  skip_before_action :verify_signed_out_user, only: :destroy

  # Sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in 'user', @user
      json_response('Sign In Successfully', true, { user: @user }, :ok)
    else
      json_response('Unauthorized', false, {}, :unauthorized)
    end
  end

  # Log out
  def destroy
    sign_out @user
    @user.generate_new_authentication_token
    json_response('Log Out Successfully', true, {}, :ok)
  end

  private

  def sign_in_params
    params.permit(:email, :password)
  end

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      @user
    else
      json_response('User not found', false, {}, :not_found)
    end
  end

  def valid_token
    @user = User.find_by(authentication_token: request.headers['Authorization'])
    if @user
      @user
    else
      json_response('Invalid Token', false, {}, :not_found)
    end
  end
end
