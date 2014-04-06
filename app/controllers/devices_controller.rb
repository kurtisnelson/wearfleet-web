class DevicesController < ApplicationController
  def index
    @devices = DeviceDecorator.decorate_collection Device.all
  end

  def show
    @device = Device.find(params[:id]).decorate
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

  def edit
    @device = Device.find(params[:id])
  end

  def update
    @device = Device.find(params[:id])
    if @device.update(device_params)
      flash[:success] = "Device updated"
      redirect_to @device
    else
      flash[:error] = "Update failed"
      render 'edit', status: 400
    end
  end

  private
  def device_params
    params.require(:device).permit(
      :fleet_id, :name
    )
  end
end
