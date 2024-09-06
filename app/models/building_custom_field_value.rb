class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field

  validate :validate_field_value

  private

  def validate_field_value
    case custom_field.field_type
    when "number"
      errors.add(:value, "must be a number") unless value.to_f.to_s == value || value.to_i.to_s == value
    when "freeform"
      # Freeform fields don't need validation
    when "enum"
      errors.add(:value, "must be one of: #{custom_field.enum_choices.join(', ')}") unless custom_field.enum_choices.include?(value)
    end
  end
end
