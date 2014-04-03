class FleetsController < ApplicationController
  def index
    @fleets = Fleet.all
  end

  def new
    @fleet = Fleet.new
  end

  def show
    @fleet = Fleet.find(params[:id])
  end

  def create
    @fleet = Fleet.new(fleet_params)
    @fleet.owner = current_user

    if @fleet.save
      flash[:success] = "Fleet created"
      redirect_to @fleet
    else
      render 'new', status: 400
    end
  end

  private
  def fleet_params
    params.require(:fleet).permit(
      :name
    )
  end
end
