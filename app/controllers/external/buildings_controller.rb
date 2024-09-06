module External
  class BuildingsController < ApplicationController
    def index
      # Default to page 1 if no page parameter is provided
      page = params[:page] || 1
      per_page = params[:per_page] || 10  # Default to 10 items per page if no per_page param is provided

      # Fetch paginated buildings using Kaminari
      buildings = Building.page(page).per(per_page)

      render json: {
        status: "success",
        buildings: buildings.as_json(include: { client: { only: :name }, building_custom_field_values: { only: [ :custom_field_id, :value ] } }),
        pagination: {
          current_page: buildings.current_page,
          next_page: buildings.next_page,
          prev_page: buildings.prev_page,
          total_pages: buildings.total_pages,
          total_count: buildings.total_count
        }
      }
    end
  end
end
