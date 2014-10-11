SailHero API
============
[![Code Climate](https://codeclimate.com/github/czajkovsky/sailhero-api.png)](https://codeclimate.com/github/czajkovsky/sailhero-api)
[![TravisCI](https://travis-ci.org/czajkovsky/sailhero-api.svg)](https://travis-ci.org/czajkovsky/sailhero-api)
[![Test Coverage](https://codeclimate.com/github/czajkovsky/sailhero-api/badges/coverage.svg)](https://codeclimate.com/github/czajkovsky/sailhero-api)

API for apps dedicated to sailors.


## Host

```
sail-hero.dev/api/v1/en
```

+ **Scoping** - API by default is accessible from api scope - <code>BASE_URL.com/api/REST_OF_THE_URL</code>
+ **Versioning** follows base url in HOST name (current version is <code>v1</code>).
+ **I18n** - currently only english version is available (<code>en</code>).

## Running API locally

##### 1. Add <code>ENV variables</code> to <code>config/application.yml</code>.
1. <code>cp config/application.yml.sample config/application.yml</code>
2. Add <code>SECRET_KEY_BASE</code> - <code>rake secret</code>.

##### 2. DB setup
1. Install Postgresql and create proper role
2. Run <code>rake db:create</code> & <code>rake db:migrate</code>

##### 3. Run server
<code>rails s</code>

## Authentication

### Create your client APP
Visit <code>http://sail-hero.dev/oauth/applications/</code> and create new application.

### Get access token
After application and [registering user](https://github.com/czajkovsky/sailhero-api/blob/master/README.md#creating-user) you can send request for access token:

##### Request
```
POST /oauth/token HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json

{
  "client_id":YOUR-CLIENT-ID,
  "client_secret":YOUR-CLIENT-SECRET,
  "username":"email@example.com",
  "grant_type":"password",
  "password":"password_example"
}
```
##### Response
```
# STATUS 200 OK
{
  access_token: YOUR-ACCESS-TOKEN
  token_type: "bearer"
  expires_in: 604800
  refresh_token: YOUR-REFRESH-TOKEN
}
```
### Revoke access token

##### Request
```
POST /ouath/revoke HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN

{
  "token":YOUR_ACCESS_TOKEN
}
```

##### Response

```
# STATUS 200 OK
{}
```

## Geolocation
This app is designed to work with geolocation services. It's highly recommended to send current position in header of every HTTP request.

##### Example Header
```
GET /api/v1/en/users/me HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
...

# request body
```

You can always check your last saved position at [your profile](https://github.com/czajkovsky/sailhero-api#authenticated-user-profile) endpoint.


## API endpoints

### Users
| Field                      | Type    | Comments                                                 | Validations                                                |
| -------------------------- | ------- | -------------------------------------------------------- | ---------------------------------------------------------- |
| <code>id</code>            | Integer |                                                          |                                                            |
| <code>email</code>         | String  |                                                          | <code>/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i</code> |
| <code>password_hash</code> | String  | Based on password which is beetween 4 and 128 characters |                                                            |
| <code>password_salt</code> | String  |                                                          |                                                            |
| <code>created_at</code>    | String  |                                                          |                                                            |
| <code>updated_at</code>    | String  |                                                          |                                                            |
| <code>name</code>          | String  |                                                          | Beetween 2 and 128 characters                              |
| <code>surname</code>       | String  |                                                          | Beetween 2 and 128 characters                              |
| <code>active</code>        | Boolean | Default: <code>true</code>                               |                                                            |

#### Creating user

##### Request
```
POST /api/v1/en/users HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json

{
  "user":{
    "email":"email@example.com",
    "password":"password_example",
    "password_confirmation":"password_example",
    "name":"Your Name",
    "surname":"Your Surname"
  }
}
```

##### Response
```
# STATUS: 201 Created
{
  "user":{
    "id":999,
    "created_at":"2014-09-13T09:57:21.402Z",
    "updated_at":"2014-09-13T09:57:21.402Z",
    "email":"email@example.com",
    "last_position":{
      "latitude":null,
      "longitude":null,
      "updated_at":null
    },
    "region":null,
    "yacht":null
  }
}
```

#### Authenticated user profile

##### Request
```
GET /api/v1/en/users HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
# STATUS: 200 OK
{
  "user":{
    "id":999,
    "created_at":"2014-09-13T09:57:21.402Z",
    "email":"email@example.com",
    "last_position":{
      "latitude:16.9765102,
      "longitude":16.9765102,
      "updated_at":"2014-10-05T15:25:21.919Z"
    }
    "region":{
      "id":1,
      "full_name":"Wielkie Jeziora Mazurskie",
      "code_name":"MAZURY"
    }
    "yacht":{
      "id":8,
      "name":"Your Yacht Name",
      "length": 780,
      "width": 230,
      "crew":7
    }
  }
}
```

#### Deactivating account

##### Request
```
DELETE /api/v1/en/users HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
# STATUS: 200 OK
{}
```

### Regions
Most of the actions (except editing user profile) require selected region. If you try to access protected resource you'll run into <code>460</code> error code.

#### Getting available regions

##### Request
```
GET /api/v1/en/regions HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
# Status: 200 OK
{
  "regions":[
    {
      "id":1,
      "full_name":"Wielkie Jeziora Mazurskie",
      "code_name":"MAZURY"
    },
    {
      "id":2,
      "full_name":"Jezioro Powidz",
      "code_name":"POWIDZ"
    }
  ]
}
```

##### Possible status codes

| Status | Description                                   |
| ------ | --------------------------------------------- |
| 200    | Everything went fine. Described above         |
| 401    | Access token is invalid or revoked.           |

#### Selecting region

##### Request
```
POST /api/v1/en/regions/1/select HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
# Status: 200 OK
{
  "region":{
    "id":1,
    "full_name":"Wielkie Jeziora Mazurskie",
    "code_name":"MAZURY"
  }
}
```

##### Possible status codes

| Status | Description                                   |
| ------ | --------------------------------------------- |
| 200    | Everything went fine. User region is updated. |
| 401    | Access token is invalid or revoked.           |
| 404    | No region with given id was found             |



### Yachts

Each user has one yacht which is used for port cost calculations.

| Field                | Type    | Comments              | Validations                   |
| -------------------- | ------- | --------------------- | ----------------------------- |
| <code>id</code>      | Integer |                       |                               |
| <code>name</code>    | String  |                       | Beetween 4 and 128 characters |
| <code>length</code>  | Integer | In centimeters        | Integer between 300 and 4000  |
| <code>width</code>   | Integer | In centimeters        | Integer between 100 and 1500  |
| <code>crew</code>    | Integer | Crew members on board | Integer between 1 and 30      |
| <code>user_id</code> | Integer |                       |                               |

#### Creating yacht

##### Request
```
POST /api/v1/en/yachts HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN

{
  "yacht":{
    "length":780,
    "width":230,
    "name":"Your Yacht Name",
    "crew":7
  }
}
```

##### Response
```
# STATUS: 201 Created
{
  "yacht":{
    id:8,
    name:"Your Yacht Name",
    length: 780,
    width: 230,
    crew:10
  }
}
```

#### Updating yacht

##### Request
```
PUT /api/v1/en/yachts/YACHT_ID HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN

{
  "yacht":{
    "name":"New yacht name"
  }
}
```

##### Response

If you're access token owner is not an owner of the yacht response status will be <code>403</code>. If data is not valid you will get response with <code>422</code> status and errors in response body. Otherwise response will look more less like:
```
# STATUS: 200 OK
{
  "yacht":{
    id:8,
    name:"New yacht name",
    length: 780,
    width: 230,
    crew:10
  }
}
```
