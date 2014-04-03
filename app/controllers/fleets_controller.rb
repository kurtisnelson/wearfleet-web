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

  def leave
    current_user.memberships.where(fleet_id: params[:fleet_id]).destroy_all
    redirect_to fleets_path
  end

  def approve
    current_user.memberships.where(fleet_id: params[:fleet_id]).each do |mem|
      mem.approved = true
      mem.save
    end
    redirect_to fleets_path
  end

  private
  def fleet_params
    params.require(:fleet).permit(
      :name
    )
  end
end
