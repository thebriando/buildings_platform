class CustomField < ApplicationRecord
  belongs_to :client
  has_many :building_custom_field_values

  validates :field_type, inclusion: { in: %w[number freeform enum] }
end
