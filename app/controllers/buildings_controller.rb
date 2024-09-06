class BuildingsController < ApplicationController
  def create
    client = Client.find_by(id: params[:client_id])

    # If client is not found, return 404
    if client.nil?
      render json: { status: "error", message: "Client not found" }, status: :not_found and return
    end

    building = client.buildings.new(building_params)

    if building.save
      validation_result = process_custom_fields(client, building, params[:building])

      if validation_result[:valid]
        render json: {
          status: "success",
          message: "Building created successfully",
          building: format_building_response(building)
        }, status: :created
      else
        render json: { status: "error", message: validation_result[:message] }, status: :bad_request
      end
    else
      render json: {
        status: "error",
        message: "Building could not be created",
        errors: building.errors.full_messages
      }, status: :bad_request
    end
  end

  def update
    client = Client.find_by(id: params[:client_id])

    # If client is not found, return 404
    if client.nil?
      render json: { status: "error", message: "Client not found" }, status: :not_found and return
    end

    building = Building.find_by(id: params[:id])

    # If building is not found, return 404
    if building.nil?
      render json: { status: "error", message: "Building not found" }, status: :not_found and return
    end

    # If building doesn't belong to the client, return 400
    if building.client_id != client.id
      render json: { status: "error", message: "Building does not belong to the specified client" }, status: :bad_request and return
    end

    # Update building and process custom fields
    if building.update(building_params)
      validation_result = process_custom_fields(client, building, params[:building])

      if validation_result[:valid]
        render json: {
          status: "success",
          message: "Building updated successfully",
          building: format_building_response(building)
        }, status: :ok
      else
        render json: { status: "error", message: validation_result[:message] }, status: :bad_request
      end
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

  # This method validates and processes custom fields
  def process_custom_fields(client, building, building_params)
    # Define the standard fields to exclude from custom field processing
    standard_fields = %w[address state zip]

    building_params.each do |key, value|
      # Skip standard fields
      next if standard_fields.include?(key)

      custom_field = client.custom_fields.find_by(name: key)

      # Return false if custom field is not found
      if custom_field.nil?
        return { valid: false, message: "Custom field '#{key}' is not defined for this client" }
      end

      # If custom field is an enum, validate the value
      if custom_field.field_type == "enum" && !custom_field.enum_choices.include?(value)
        return { valid: false, message: "Value '#{value}' for custom field '#{key}' is not valid. Valid options are: #{custom_field.enum_choices.join(', ')}" }
      end

      # If validation passes, save or update the custom field value
      custom_value = building.building_custom_field_values.find_or_initialize_by(custom_field: custom_field)
      custom_value.update!(value: value)
    end

    { valid: true }
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
