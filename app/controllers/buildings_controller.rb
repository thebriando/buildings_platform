class BuildingsController < ApplicationController
  def create
    client = Client.find(params[:client_id])
    building = client.buildings.new(building_params)

    if building.save
      # Process custom fields dynamically
      invalid_fields = process_custom_fields(client, building)

      # Handle invalid custom fields
      if invalid_fields.any?
        render json: {
          status: "error",
          message: "Invalid custom fields",
          invalid_fields: invalid_fields
        }, status: :bad_request and return  # Stop execution here
      end

      # If no invalid fields, return the success response
      render json: {
        status: "success",
        message: "Building created successfully",
        building: format_building_response(building)
      }, status: :created
    else
      # Return 400 if validation fails
      render json: {
        status: "error",
        message: "Building could not be created",
        errors: building.errors.full_messages
      }, status: :bad_request
    end
  end

  def update
    building = Building.find(params[:id])

    if building.update(building_params)
      # Handle invalid custom fields
      invalid_fields = process_custom_fields(building.client, building)

      if invalid_fields.any?
        render json: {
          status: "error",
          message: "Invalid custom fields",
          invalid_fields: invalid_fields
        }, status: :bad_request and return
      end

      # If no invalid fields, return the success response
      render json: {
        status: "success",
        message: "Building updated successfully",
        building: format_building_response(building)
      }, status: :ok
    else
      render json: {
        status: "error",
        message: "Building could not be updated",
        errors: building.errors.full_messages
      }, status: :bad_request
    end
  end

  def index
    buildings = Building.page(params[:page]).per(10)
    render json: buildings, include: [ :client, :custom_fields ]
  end

  private

  def building_params
    params.require(:building).permit(:address, :state, :zip)
  end

  # Process custom fields and return a list of invalid fields (if any)
  def process_custom_fields(client, building)
    custom_field_params = params[:building].except(:address, :state, :zip)
    invalid_fields = []

    custom_field_params.each do |field_name, field_value|
      # Check if the custom field exists for the client
      custom_field = client.custom_fields.find_by(name: field_name)

      if custom_field
        # Find or initialize the BuildingCustomFieldValue for the building
        custom_value = building.building_custom_field_values.find_or_initialize_by(custom_field: custom_field)
        unless custom_value.update(value: field_value)
          invalid_fields << { field_name => custom_value.errors.full_messages }
        end
      else
        invalid_fields << field_name  # Collect invalid field names
      end
    end

    invalid_fields
  end

  # Format the building response to include custom fields
  def format_building_response(building)
    # Load building custom field values with associated custom fields
    custom_fields = building.building_custom_field_values.includes(:custom_field).each_with_object({}) do |field_value, hash|
      hash[field_value.custom_field.name] = field_value.value
    end

    # Merge the standard fields (address, state, zip) with the custom fields
    {
      id: building.id,
      address: building.address,
      state: building.state,
      zip: building.zip
    }.merge(custom_fields)
  end
end
