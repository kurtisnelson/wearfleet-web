class DevicesController < ApplicationController
  def index
    @devices = Device.all
  end

  def show
    @device = Device.find(params[:id])
  end

  def new
    @device = Device.new
    @device.user_id = params[:user_id]
  end

  def create
    @device = Device.new(device_params)
    @device.user = current_user

    if @device.save
      flash[:success] = "Device created"
      redirect_to [@device.user, @device]
    else
      render 'new', status: 400
    end
  end

  private
  def device_params
    params.require(:device).permit(
      :fleet_id, :name
    )
  end
end
