class Building < ApplicationRecord
  belongs_to :client
  has_many :building_custom_field_values, dependent: :destroy
  has_many :custom_fields, through: :client

  validates :address, :state, :zip, presence: true
end
