# Clear existing data
# BuildingCustomFieldValue.delete_all
# Building.delete_all
# CustomField.delete_all
# Client.delete_all

# Create Clients
client1 = Client.create!(name: "Client One")
client2 = Client.create!(name: "Client Two")
client3 = Client.create!(name: "Client Three")

# Define custom fields for Client One
client1_custom_fields = [
  { name: "bathroom_count", field_type: "number" },
  { name: "living_room_color", field_type: "freeform" },
  { name: "walkway_type", field_type: "enum", enum_choices: [ "Brick", "Concrete", "None" ] }
]

client1_custom_fields.each do |field|
  client1.custom_fields.create!(field)
end

# Define custom fields for Client Two
client2_custom_fields = [
  { name: "garage_size", field_type: "number" },
  { name: "kitchen_color", field_type: "freeform" }
]

client2_custom_fields.each do |field|
  client2.custom_fields.create!(field)
end

# Define custom fields for Client Three
client3_custom_fields = [
  { name: "pool_size", field_type: "number" },
  { name: "roof_type", field_type: "enum", enum_choices: [ "Tile", "Metal", "Shingle" ] }
]

client3_custom_fields.each do |field|
  client3.custom_fields.create!(field)
end

# Create buildings for Client One
building1 = client1.buildings.create!(address: "123 Main St", state: "NY", zip: "10001")
building2 = client1.buildings.create!(address: "456 Elm St", state: "CA", zip: "90210")

# Add custom field values for buildings of Client One
building1.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "bathroom_count"), value: "2.5")
building1.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "living_room_color"), value: "Blue")
building1.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "walkway_type"), value: "Brick")

building2.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "bathroom_count"), value: "3")
building2.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "living_room_color"), value: "Green")
building2.building_custom_field_values.create!(custom_field: client1.custom_fields.find_by(name: "walkway_type"), value: "Concrete")

# Create buildings for Client Two
building3 = client2.buildings.create!(address: "789 Pine St", state: "TX", zip: "73301")
building4 = client2.buildings.create!(address: "101 Oak St", state: "FL", zip: "33101")

# Add custom field values for buildings of Client Two
building3.building_custom_field_values.create!(custom_field: client2.custom_fields.find_by(name: "garage_size"), value: "2")
building3.building_custom_field_values.create!(custom_field: client2.custom_fields.find_by(name: "kitchen_color"), value: "Red")

building4.building_custom_field_values.create!(custom_field: client2.custom_fields.find_by(name: "garage_size"), value: "1")
building4.building_custom_field_values.create!(custom_field: client2.custom_fields.find_by(name: "kitchen_color"), value: "White")

# Create buildings for Client Three
building5 = client3.buildings.create!(address: "202 Birch St", state: "AZ", zip: "85001")
building6 = client3.buildings.create!(address: "303 Maple St", state: "NV", zip: "89101")

# Add custom field values for buildings of Client Three
building5.building_custom_field_values.create!(custom_field: client3.custom_fields.find_by(name: "pool_size"), value: "25")
building5.building_custom_field_values.create!(custom_field: client3.custom_fields.find_by(name: "roof_type"), value: "Tile")

building6.building_custom_field_values.create!(custom_field: client3.custom_fields.find_by(name: "pool_size"), value: "30")
building6.building_custom_field_values.create!(custom_field: client3.custom_fields.find_by(name: "roof_type"), value: "Shingle")
