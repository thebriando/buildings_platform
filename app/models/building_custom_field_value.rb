class BuildingCustomFieldValue < ApplicationRecord
  belongs_to :building
  belongs_to :custom_field
end
