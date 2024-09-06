class AddAdditionalIndexes < ActiveRecord::Migration[7.2]
  def change
    # Add index for name on clients table if you frequently search for clients by name
    add_index :clients, :name

    # Add indexes for state and zip on buildings table if you frequently filter buildings by location
    add_index :buildings, :state
    add_index :buildings, :zip
  end
end
