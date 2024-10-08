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

  # This method validates and processes custom fields, including type validation
  def process_custom_fields(client, building, building_params)
    standard_fields = %w[address state zip]

    building_params.each do |key, value|
      next if standard_fields.include?(key)

      custom_field = client.custom_fields.find_by(name: key)

      if custom_field.nil?
        return { valid: false, message: "Custom field '#{key}' is not defined for this client" }
      end

      # Validate and store the value based on the field type
      case custom_field.field_type
      when "number"
        unless value.is_a?(Numeric)
          return { valid: false, message: "Value '#{value}' for custom field '#{key}' must be a number" }
        end
        # Save the value as a number
        value_to_store = value
      when "freeform"
        unless value.is_a?(String)
          return { valid: false, message: "Value '#{value}' for custom field '#{key}' must be a string" }
        end
        value_to_store = value
      when "enum"
        unless custom_field.enum_choices.include?(value)
          return { valid: false, message: "Value '#{value}' for custom field '#{key}' is not valid. Valid options are: #{custom_field.enum_choices.join(', ')}" }
        end
        value_to_store = value
      else
        return { valid: false, message: "Invalid field type for custom field '#{key}'" }
      end

      # Store the custom field value
      custom_value = building.building_custom_field_values.find_or_initialize_by(custom_field: custom_field)
      custom_value.update!(value: value_to_store)
    end

    { valid: true }
  end

  # Format the building response to include custom fields
  def format_building_response(building)
    response = {
      id: building.id,
      address: building.address,
      state: building.state,
      zip: building.zip
    }

    # Fetch all custom fields for the building's client
    client_custom_fields = building.client.custom_fields

    # Map the custom fields to the response, with their values or nil if not set
    client_custom_fields.each do |custom_field|
      field_name = custom_field.name
      custom_value = building.building_custom_field_values.find_by(custom_field: custom_field)

      # Assign the value if it's present, otherwise nil
      if custom_value.present?
        if custom_field.field_type == "number"
          response[field_name] = custom_value.value.to_f
        else
          response[field_name] = custom_value.value
        end
      else
        # If no value is set, return nil
        response[field_name] = nil
      end
    end

    response
  end
end
