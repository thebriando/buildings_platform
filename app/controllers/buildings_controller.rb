class BuildingsController < ApplicationController
  def create
    client = Client.find(params[:client_id])
    building = client.buildings.new(building_params)
    if building.save
      render json: { status: "success", message: "Building created successfully" }, status: :created
    else
      render json: { status: "error", message: building.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    building = Building.find(params[:id])
    if building.update(building_params)
      render json: { status: "success", message: "Building updated successfully" }
    else
      render json: { status: "error", message: building.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def building_params
    params.require(:building).permit(:address, :state, :zip)
  end
end
