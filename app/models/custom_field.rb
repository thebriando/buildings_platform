class CustomField < ApplicationRecord
  belongs_to :client

  validates :field_type, inclusion: { in: %w[number freeform enum] }

  # Only validate enum choices if field_type is 'enum'
  validate :validate_enum_choices, if: -> { field_type == "enum" }

  private

  def validate_enum_choices
    if field_type == "enum" && enum_choices.blank?
      errors.add(:enum_choices, "must be present for enum fields")
    end
  end
end
