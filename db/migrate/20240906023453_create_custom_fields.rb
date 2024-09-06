class CreateCustomFields < ActiveRecord::Migration[7.2]
  def change
    create_table :custom_fields do |t|
      t.string :name
      t.string :field_type
      t.references :client, foreign_key: true
      t.text :enum_choices

      t.timestamps
    end
  end
end
