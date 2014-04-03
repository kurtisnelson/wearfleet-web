class MembershipsController < ApplicationController
  def new
    @membership = Membership.new
    @membership.fleet_id = params[:fleet_id]
  end

  def create
    @membership = Membership.new(membership_params)
    @membership.fleet_id = params[:fleet_id]
    @membership.user_id = params[:membership][:user_id]

    if @membership.save
      flash[:success] = "Membership created"
      redirect_to @membership.fleet
    else
      flash[:error] = "Could not create membership"
      redirect_to @membership.fleet
    end
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
       flash[:success] = "Membership updated"
       redirect_to @membership.fleet
    else
      flash[:error] = "Update failed"
      render 'edit', status: 400
    end
  end

  private
  def membership_params
    params.require(:membership).permit(
      :admin, :dispatcher
    )
  end
end
