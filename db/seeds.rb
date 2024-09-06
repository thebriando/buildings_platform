Client.create!([
  { name: 'Client One' },
  { name: 'Client Two' },
  { name: 'Client Three' },
  { name: 'Client Four' },
  { name: 'Client Five' }
])

# Add custom fields and buildings for the clients
Client.all.each do |client|
  client.custom_fields.create!(name: 'Custom Field 1', field_type: 'number')
  client.custom_fields.create!(name: 'Custom Field 2', field_type: 'freeform')

  client.buildings.create!(address: '123 Main St', state: 'NY', zip: '10001')
  client.buildings.create!(address: '456 Second St', state: 'CA', zip: '90210')
end
