module External
  class BuildingsController < ApplicationController
    def index
      # Default to page 1 if no page parameter is provided
      page = params[:page] || 1
      per_page = params[:per_page] || 10  # Default to 10 items per page if no per_page param is provided

      # Fetch paginated buildings
      buildings = Building.page(page).per(per_page)

      render json: {
        status: "success",
        buildings: buildings.map { |building| format_building_response(building) },
        pagination: {
          current_page: buildings.current_page,
          next_page: buildings.next_page,
          prev_page: buildings.prev_page,
          total_pages: buildings.total_pages,
          total_count: buildings.total_count
        }
      }
    end
    # Format the building response to include custom fields
    def format_building_response(building)
      # Collect custom field values
      custom_fields = building.building_custom_field_values.includes(:custom_field).each_with_object({}) do |field_value, hash|
        hash[field_value.custom_field.name] = field_value.value
      end

      # Return the building details
      {
        id: building.id,
        address: building.address,
        state: building.state,
        zip: building.zip,
        client_name: building.client.name
      }.merge(custom_fields)
    end
  end
end
