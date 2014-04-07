class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :authenticate_user_from_token!
  before_action :authenticate_user!

  def authenticate_user_from_token!
    user_email = params[:user_email].presence
    user       = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, params[:user_token])
      sign_in user, store: false
    end
  end
end
