class ExternalBuildingsController < ApplicationController
  def index
    buildings = Building.all
    render json: {
      status: "success",
      buildings: buildings.as_json(include: { client: { only: :name }, building_custom_field_values: { only: [ :custom_field_id, :value ] } })
    }
  end
end
