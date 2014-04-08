class UsersController < ApplicationController
  protect_from_forgery except: :pusher_auth # stop rails CSRF protection for this action

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def pusher_auth
    if current_user
      id = current_user.id
      if current_user.device_ids.include? params[:device_id]
        id += "-"
        id += params[:device_id]
      end
      response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
        user_id: id,
        user_info: {
          name: current_user.name,
          email: current_user.email,
          devices: current_user.device_ids
        }
      })
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end
end
