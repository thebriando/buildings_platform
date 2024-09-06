# Clear existing data
BuildingCustomFieldValue.delete_all
Building.delete_all
CustomField.delete_all
Client.delete_all

# Create 5 clients
clients = [
  { name: "Client One" },
  { name: "Client Two" },
  { name: "Client Three" },
  { name: "Client Four" },
  { name: "Client Five" }
]

clients.each do |client_data|
  client = Client.create!(name: client_data[:name])

  # Create custom fields for each client
  custom_fields = [
    { name: "bathroom_count", field_type: "number" },
    { name: "living_room_color", field_type: "freeform" },
    { name: "walkway_type", field_type: "enum", enum_choices: [ "Brick", "Concrete", "None" ] }
  ]

  custom_fields.each do |field|
    client.custom_fields.create!(field)
  end

  # Create buildings for each client
  building1 = client.buildings.create!(address: "123 Main St", state: "NY", zip: "10001")
  building2 = client.buildings.create!(address: "456 Elm St", state: "CA", zip: "90210")

  # Add custom field values for each building
  building1.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "bathroom_count"), value: 2.5)
  building1.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "living_room_color"), value: "Blue")
  building1.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "walkway_type"), value: "Brick")

  building2.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "bathroom_count"), value: 3)
  building2.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "living_room_color"), value: "Green")
  building2.building_custom_field_values.create!(custom_field: client.custom_fields.find_by(name: "walkway_type"), value: "Concrete")
end

puts "Seeded 5 clients with buildings and custom fields."
