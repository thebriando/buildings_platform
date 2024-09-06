class ChangeValueColumnTypeInBuildingCustomFieldValues < ActiveRecord::Migration[7.2]
  def change
    # Change value column to jsonb to allow multiple data types
    change_column :building_custom_field_values, :value, :jsonb, using: 'value::jsonb'
  end
end
