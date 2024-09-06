# README

# Dependencies:

- RVM
  `> brew install rvm`
- Ruby
  `> rvm install ruby`
- Rails
  `> sudo gem install rails`
- Postgres
  ```
  > brew install postgresql
  > brew services start postgresql
  ```

# Instructions

## Clone Repo

- `> git clone https://github.com/your-repo/building-platform.git`
- `> cd building-platform`

## Start Rails Server

- Install dependencies
  `> bundle install`
- Setup db
  `> rails db:create db:migrate`
- Seed the database
  `> rails db:seed`
- Start server
  `> rails server`

## Clients

Clients are defined in the seed file, refer to `db/seeds.rb` to get the clients defined for the app.
To get client ids and building ids:

- Run `rails console`
- Run `Client.all` to get all clients and their ids
- Run `Building.all` to get all buildilngs and building ids

## Testing the API

- Download Postman, or use curl
- With the rails server running, use the following endpoints with the url of the rails server (probably `http://127.0.0.1:3000`)

## Available Endpoints

### `POST /clients/:client_id/buildings`

Adds a building for a client.

Request body:

```
{
  "building": {
    "address": (string, required) The street address of the building.
    "state": (string, required) The state where the building is located.
    "zip": (string, required) The ZIP code for the building.
    [custom_field]: Any custom fields defined for the client. These fields will vary depending on the client's configuration. Their values can either be numbers, freeforms, or enums
  }
}
```

- Address, state, and zip are required: If any of these fields are missing, the request will fail with a 400.
- Custom fields must be valid: Any custom fields in the request body must be defined for the client. If an different custom field is included, a 400 will be returned with the invalid fields

Request Paramaters:

- `client_id`: id of the client

Example request:

`POST http://127.0.0.1:3000/1/buildings`

Request body:

```
{
  "building": {
    "address": "123 Main St",
    "state": "NY",
    "zip": "10001",
    "bathroom_count": 2.5,
    "living_room_color": "Blue",
  }
}
```

### `PUT /clients/:client_id/buildings/:building_id`

Updates a building for a client.

Request body:

```
{
  "building": {
    "address": (string, required) The street address of the building.
    "state": (string, required) The state where the building is located.
    "zip": (string, required) The ZIP code for the building.
    [custom_field]: Any custom fields defined for the client. These fields will vary depending on the client's configuration.
  }
}
```

- Address, state, and zip are required: If any of these fields are missing, the request will fail with a 400.
- Custom fields must be valid: Any custom fields in the request body must be defined for the client. If an different custom field is included, a 400 will be returned with the invalid fields

Request Paramaters:

- `client_id`: id of the client
- `building_id`: id of the building to update

Example request:
`POST http://127.0.0.1:3000/1/buildings/1`

Request body:

```
{
  "building": {
    "address": "456 Elm St",
    "state": "CA",
    "zip": "90210",
    "bathroom_count": 4,
    "living_room_color": "Green",
    "walkway_type": "Brick"
  }
}

```

### `GET /external/buildings`

Gets all buildings

Request Parameters:

- `page` (optional): The page number for pagination.
  - Example: `/external/buildings?page=2`
- `per_page` (optional): The number of buildings to return per page.
  - Example: `/external/buildings?per_page=10`

Example Response:

```
{
    "status": "success",
    "buildings": [
        {
            "id": 1,
            "address": "123 Main St",
            "state": "NY",
            "zip": "10001",
            "client_name": "Client One",
            "bathroom_count": 2.5,
            "living_room_color": "Blue",
            "walkway_type": "Brick"
        },
        {
            "id": 2,
            "address": "456 Elm St",
            "state": "CA",
            "zip": "90210",
            "client_name": "Client One",
            "bathroom_count": 3,
            "living_room_color": "Green",
            "walkway_type": "Concrete"
        }
    ],
    "pagination": {
        "current_page": 1,
        "next_page": 2,
        "prev_page": null,
        "total_pages": 6,
        "total_count": 12
    }
}
```

# Troubleshooting

If you see this error:

```

Couldn't create 'buildings_platform_development' database. Please check your configuration.
bin/rails aborted!
ActiveRecord::ConnectionNotEstablished: connection to server on socket "/tmp/.s.PGSQL.5432" failed: No such file or directory (ActiveRecord::ConnectionNotEstablished)

```

Try running this:

```

> rm /usr/local/var/postgres/postmaster.pid
> brew services restart postgresql

```
