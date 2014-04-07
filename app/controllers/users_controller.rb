class UsersController < ApplicationController
  protect_from_forgery :except => :auth # stop rails CSRF protection for this action

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def pusher_auth
    if current_user
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        :user_id => current_user.id, # => required
        :user_info => { # => optional - for example
          :name => current_user.name,
          :email => current_user.email
        }
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end
end
