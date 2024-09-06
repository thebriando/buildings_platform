class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  validates :value, presence: true
  validate :validate_field_value

  private

  # Validate the custom field value based on its field type
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
    valid_enum_choices = custom_field.enum_choices.map(&:strip)

    # Check if the provided value is in the list of valid enum choices
    unless valid_enum_choices.include?(value.strip)
      errors.add(:value, "must be one of: #{valid_enum_choices.join(', ')}")
    end
  end
end
