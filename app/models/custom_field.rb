class CustomField < ApplicationRecord
  # Associations
  has_many :building_custom_field_values, dependent: :destroy
  belongs_to :client

  # Validations
  validates :name, presence: true
  validates :field_type, presence: true, inclusion: { in: %w[number freeform enum] }
  validate :validate_enum_choices

  private

  # Ensure enum_choices is an array when field_type is 'enum'
  def validate_enum_choices
    if field_type == "enum" && (!enum_choices.is_a?(Array) || enum_choices.blank?)
      errors.add(:enum_choices, "must be an array of valid options for enum fields")
    end
  end
end
