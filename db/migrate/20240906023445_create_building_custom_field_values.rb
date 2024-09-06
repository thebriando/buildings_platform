class CreateBuildingCustomFieldValues < ActiveRecord::Migration[7.2]
  def change
    create_table :building_custom_field_values do |t|
      t.references :building, foreign_key: true
      t.references :custom_field, foreign_key: true
      t.string :value

      t.timestamps
    end
  end
end
