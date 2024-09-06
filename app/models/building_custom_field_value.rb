class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  # Validation for the value field depending on the field type
  validate :validate_field_value

  private

  def validate_field_value
    if custom_field.field_type == "number"
      unless value.is_a?(Numeric)
        errors.add(:value, "must be a valid number")
      end
    elsif custom_field.field_type == "freeform"
      unless value.is_a?(String)
        errors.add(:value, "must be a string")
      end
    elsif custom_field.field_type == "enum"
      unless custom_field.enum_choices.include?(value)
        errors.add(:value, "must be one of: #{custom_field.enum_choices.join(', ')}")
      end
    end
  end
end
