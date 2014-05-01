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
      if params[:channel_name].starts_with? 'private'
        response = Pusher[params[:channel_name]].authenticate(params[:socket_id])
      else
        id = current_user.id.to_s
        if params[:device_id] && current_user.device_ids.include?(Integer(params[:device_id]))
          id += "-"
          id += params[:device_id]
        end
        response = Pusher[params[:channel_name]].authenticate(params[:socket_id], {
          user_id: id,
          user_info: {
            name: current_user.name,
            email: current_user.email
          }
        })
      end
      render :json => response
    else
      render :text => "Forbidden", :status => '403'
    end
  end

  def token
    @user = User.find(params[:user_id])
    @user.authentication_token = nil
    if @user.save
      flash[:success] = "Authentication reset"
      redirect_to :back
    else
      flash[:error] = "Reset failed"
      redirect_to :back
    end
  end
end
