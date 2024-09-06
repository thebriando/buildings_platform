class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  validates :value, presence: true
  validate :validate_field_value

  private

  # Validate that the value corresponds to the field type (number, freeform, enum)
  def validate_field_value
    case custom_field.field_type
    when "number"
      validate_number_value
    when "enum"
      validate_enum_value
    end
  end

  def validate_number_value
    unless value.to_f.to_s == value || value.to_i.to_s == value
      errors.add(:value, "must be a valid number")
    end
  end

  def validate_enum_value
    # Ensure enum_choices is an array and validate against it
    valid_enum_choices = custom_field.enum_choices.is_a?(Array) ? custom_field.enum_choices : custom_field.enum_choices.split(",")
    unless valid_enum_choices.include?(value)
      errors.add(:value, "must be one of: #{valid_enum_choices.join(', ')}")
    end
  end
end
