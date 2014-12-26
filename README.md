SailHero API
============
[![Code Climate](https://codeclimate.com/github/czajkovsky/sailhero-api.png)](https://codeclimate.com/github/czajkovsky/sailhero-api)
[![TravisCI](https://travis-ci.org/czajkovsky/sailhero-api.svg)](https://travis-ci.org/czajkovsky/sailhero-api)
[![Test Coverage](https://codeclimate.com/github/czajkovsky/sailhero-api/badges/coverage.svg)](https://codeclimate.com/github/czajkovsky/sailhero-api)

API for apps dedicated to sailors.

+ [Host](#host)
+ [Running API locally](#running-api-locally)
+ [Authentication](#authentication)
  + [Create your client app](#create-your-client-app)
  + [Get access token](#get-access-token)
  + [Revoke access token](#revoke-access-token)
+ [Geolocation](#geolocation)
+ [API endpoints](#api-endpoints)
  + [Users](#users)
    + [Searching users](#searching-users)
    + [Creating user](#creating-user)
    + [Editing user](#editing-user)
    + [Authenticated user profile](#authenticated-user-profile)
    + [Deactivating account](#deactivating-account)
    + [Adding devices](#adding-devices)
  + [Messages](#messages)
    + [Sending message](#sending-message)
    + [Fetching messages](#fetching-messages)
    + [Fetching single message](#fetching-single-message)
  + [Friendships](#friendships)
    + [Getting all your friendships (accepted)](#getting-all-your-friendships-accepted)
    + [Getting your pending friendships requests](#getting-your-pending-friendships-requests)
    + [Getting sent friendships invites](#getting-sent-friendships-invites)
    + [Getting full friendships list in one request (accepted, sent and pending)](#getting-full-friendships-list-in-one-request-accepted-sent-and-pending)
    + [Creating new friendship](#creating-new-friendship)
    + [Accepting/blocking/denying friendship request](#acceptingblockingdenying-friendship-request)
    + [Friendship status codes](#friendship-status-codes)
  + [Regions](#regions)
    + [Getting available regions](#getting-available-regions)
    + [Selecting region](#selecting-region)
  + [Yachts](#yachts)
    + [Creating yacht](#creating-yacht)
    + [Updating yacht](#updating-yacht)
  + [Alerts](#alerts)
    + [Creating an alert](#creating-an-alert)
    + [Geting single alert](#geting-single-alert)
    + [Confirming/canceling alert](#confirmingcanceling-alert)
    + [Possible alert types](#possible-alert-types)
  + [Ports](#ports)
    + [Getting all ports](#getting-all-ports)
    + [Getting single ports](#getting-all-ports)
    + [Calculating port cost](#calculating-port-cost)
  + [Routes](#routes)
    + [Getting all routes](#getting-all-routes)
    + [Getting single route](#getting-single-route)
+ [Custom API status codes](#custom-api-status-codes)


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

#### Searching users

##### Request
```
GET /api/v1/en/users?q=scarlett HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
```

##### Response
```
# STATUS: 200 OK
{
  "users":[
    {
      "id":999,
      "name":"Scarlett",
      "surname":"Johansson",
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
  ]
}
```

##### Possible status codes

| Status | Description                                              |
| ------ | -------------------------------------------------------- |
| 200    | Everything went fine. Server responds with matched users |
| 401    | Access token is invalid or revoked.                      |

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
    "surname":"Your Surname",
    "avatar_data":"data:image/jpg;base64,YOUR-AVATAR-BASE64-ENCODED"
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
    "yacht":null,
    "avatar_url":"AVATAR-URL"
  }
}
```

#### Editing user

##### Request
```
PUT /api/v1/en/users/:id HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json

{
  "user":{
    "email":"new-email@example.com",
  }
}
```

##### Response

Same as for **creating user**.

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

#### Adding devices

##### Request
```
GET /api/v1/en/users/me/devices HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN

{
  "device_type":"ANDROID",
  "name":"YOUR DEVICE NAME"
  "key":"YOUR_GCM_OR_IOS_KEY"
}
```

##### Response
```
# STATUS: 201 OK
{
  device: {
    id: 3,
    name:"YOUR_DEVICE_NAME",
    device_type:"ANDROID",
    key: "YOUR_GCM_KEY",
    created_at: "2014-11-02T14:25:29.722Z"
 }
}
```

##### Possible status codes

| Status | Description                                   |
| ------ | --------------------------------------------- |
| 201    | Everything went fine. GCM key created         |
| 401    | Access token is invalid or revoked.           |
| 422    | Provided data is invalid                      |

##### Device types

Currently only <code>ANDROID</code> with GCM as <code>key</code> is supported.

### Messages

#### Sending message

##### Request
```
POST /api/v1/en/messages HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Latitude: YOUR-LATITUDE
Longitude: YOUR-LONGITUDE
Authorization: Bearer YOUR-TOKEN

{
  "message":{
    "body":"YOUR-MESSAGE"
  }
}
```

##### Response
```
# STATUS: 201 Created
{
  "message":{
    "id":999,
    "body":"YOUR-MESSAGE",
    "created_at":"2014-09-13T09:57:21.402Z",
    "user_id":"YOUR-ID",
    "latitude":"YOUR-LATITUDE",
    "longitude":"YOUR-LONGITUDE"
  }
}
```

##### Possible status codes

| Status | Description                                     |
| ------ | ----------------------------------------------- |
| 201    | Everything went fine. Described above           |
| 401    | Access token is invalid or revoked.             |
| 460    | Your current <code>region_id</code> is invalid. |

#### Fetching messages

Fetching messages is cursor style - we have three parameters:
* <code>order</code> - <code>ASC</code> (default) and <code>DESC</code> allowed. <code>DESC</code> fetches previous messages.
* <code>since</code> - id of first message that will be included in response
* <code>limit</code> - how many messages will be included, <code>25</code> by default, <code>100</code> is maximum, can't be less then <code>1</code>

If you don't provide any of the paramters API will respond with **25 last messages**.

##### Request
```
GET /api/v1/en/messages/limit=5&since=15&order=ASC HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Latitude: YOUR-LATITUDE
Longitude: YOUR-LONGITUDE
Authorization: Bearer YOUR-TOKEN
```

##### Response
```
# STATUS: 200 OK
{
  "messages":[
    {
      "id":5,
      "body","MESSAGE-BODY",
      "created_at":"2014-09-13T09:57:21.402Z",
      "user_id":"AUTHOR-ID",
      "latitude":"MESSAGE-LATITUDE",
      "longitude":"MESSAGE-LONGITUDE"
    }
    # ...
  ],
  next: NEXT-MESSAGE-ID
}
```

##### Examples
Let't assume we have 6 messages with ID's <code>1</code>, <code>2</code>, <code>3</code>, <code>4</code>, <code>5</code> and <code>6</code>.

| Since | Limit | Order | IDs included     | Next message id |
| ----- | ----- | ----- | ---------------- | --------------- |
| 4     | 2     | DESC  | 4, 3             | 2               |
| 4     | 2     | -     | 4, 5             | 6               |
| 4     | 10    | -     | 4, 5, 6          | nil             |
| -     | -     | -     | 6, 5, 4, 3, 2, 1 | nil             |

##### Possible status codes

| Status | Description                                     |
| ------ | ----------------------------------------------- |
| 200    | Everything went fine. Described above           |
| 401    | Access token is invalid or revoked.             |
| 460    | Your current <code>region_id</code> is invalid. |

#### Fetching single message

##### Request
```
GET /api/v1/en/messages/:id HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Latitude: YOUR-LATITUDE
Longitude: YOUR-LONGITUDE
Authorization: Bearer YOUR-TOKEN
```

##### Response
```
# STATUS: 200 OK
{
  "message":{
    "id":999,
    "body","YOUR-MESSAGE",
    "created_at":"2014-09-13T09:57:21.402Z",
    "user_id":"AUTHOR-ID",
    "latitude":"MESSAGE-LATITUDE",
    "longitude":"MESSAGE-LONGITUDE"
  }
}
```

##### Pagination
Messages are paginated - you can switch <code>page</code> (by default <code>0</code>) and <code>per</code> (by default <code>25</code>).

##### Possible status codes

| Status | Description                                                                    |
| ------ | ------------------------------------------------------------------------------ |
| 200    | Everything went fine. Described above                                          |
| 401    | Access token is invalid or revoked.                                            |
| 404    | Message with given id was not found.                                           |
| 460    | Your current <code>region_id</code> is invalid or doesn't match message region |

#### Message latitude and longitude

If user allows position tracking and sends his position in headers message sent position is saved as well. Otherwise it's casted to <code>nil</code>.

### Friendships
This app is meant to be social. It wouldn't be possible without friends. Making friends at Sailhero is very easy!

#### Getting all your friendships (accepted)

##### Request
```
GET /api/v1/en/friendships/accepted HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
# STATUS: 200 OK
{
  "friendships":[
    {
      "id":3,
      "status":1,
      "invited":true,
      "friend":{
        "id":"YOUR_FRIEND_ID",
        "email":"YOUR_FRIEND_EMAIL",
        "name":"YOUR_FRIEND_NAME",
        "surname":"YOUR_FRIEND_SURNAME"
      }
      "created_at": "2014-11-23T11:26:13.725Z",
      "updated_at": "2014-11-23T11:26:13.731Z"
    },
    {
      "id":13,
      "status":1,
      "invited":false,
      "friend":{
        "id":"YOUR_ID",
        "email":"YOUR_EMAIL",
        "name":"YOUR_NAME",
        "surname":"YOUR_SURNAME"
      }
      "created_at": "2014-11-23T11:26:13.725Z",
      "updated_at": "2014-11-23T11:26:13.731Z"
    }
  ]
}
```

##### Possible status codes

| Status | Description                                   |
| ------ | --------------------------------------------- |
| 200    | Everything went fine. Described above         |
| 401    | Access token is invalid or revoked.           |

#### Getting your pending friendships requests

##### Request
```
GET /api/v1/en/friendships/pending HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

Response and possible status codes look very similar to **getting all friendships** - only difference: each friendship has <code>0</code> (<code>PENDING</code> status).

#### Getting sent friendships invites

##### Request
```
GET /api/v1/en/friendships/sent HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

Response and possible status codes look very similar to **getting all friendships** - only difference: each friendship has <code>0</code> (<code>PENDING</code> status).

#### Getting full friendships list in one request (accepted, sent and pending)

##### Request
```
GET /api/v1/en/friendships HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response
```
"accepted":[
  # ... list of accepted friendships
],
"pending":[
  # ... list of pending friendships requests
],
"sent":[
  # ... list of sent friendships requests
]
```

#### Creating new friendship

##### Request

```
POST /api/v1/en/friendships HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN

{
  "friend_id":YOUR_FUTURE_FRIEND_ID
}
```

##### Response
```
# STATUS 201 Created
"friendship":{
  "id":3,
  "status":0,
  "invited":false,
  "friend":{
    "id":"YOUR_FRIEND_ID",
    "email":"YOUR_FRIEND_EMAIL",
    "name":"YOUR_FRIEND_NAME",
    "surname":"YOUR_FRIEND_SURNAME"
  },
  "created_at": "2014-11-23T11:26:13.725Z",
  "updated_at": "2014-11-23T11:26:13.731Z"
}
```

##### Possible status codes

| Status | Description                                                  |
| ------ | ------------------------------------------------------------ |
| 201    | Everything went fine. Described above                        |
| 401    | Access token is invalid or revoked.                          |
| 403    | Friendship already exists (any state allowed).               |
| 462    | Forever alone - you're trying to make friends with yourself. |
| 463    | You're trying to become friends with <code>nil</code>.       |


#### Deleting friendship

##### Request

```
DELETE /api/v1/en/friendships/:id HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response

```
# STATUS 200 OK
{}
```

##### Possible status codes

| Status | Description                                                  |
| ------ | ------------------------------------------------------------ |
| 200    | Everything went fine. Described above                        |
| 401    | Access token is invalid or revoked.                          |
| 403    | Your not either friend neither user in this friendship.      |
| 404    | Friendship with given ID doesn't exist.                      |

#### Accepting/denying friendship request

##### Accepting

```
POST /api/v1/en/friendships/:id/accept HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Denying

```
POST /api/v1/en/friendships/:id/deny HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Canceling

```
POST /api/v1/en/friendships/:id/cancel HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
```

##### Response

For **accepting** - standard friendship response (see creating new friendship).
For **denying** and **canceling**:
```
# STATUS 200 OK
{}
```

##### Possible status codes

| Status | Description                                                                 |
| ------ | --------------------------------------------------------------------------- |
| 200    | Everything went fine. Described above                                       |
| 401    | Access token is invalid or revoked.                                         |
| 403    | This friendship is not in pending state or you're not allowed to accept it. |
| 404    | Friendship with given id doesn't exist.                                     |

#### Friendship status codes
There can be 2 status codes:
+ <code>0</code> - <code>PENDING</code> (default)
+ <code>1</code> - <code>ACCEPTED</code>

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

##### Possible status codes

| Status | Description                             |
| ------ | --------------------------------------- |
| 201    | Everything went fine. Yacht is created. |
| 401    | Access token is invalid or revoked.     |
| 422    | Provided data is invalid                |
| 461    | Current user has already created yacht. |

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
    "id":8,
    "name":"New yacht name",
    "length":780,
    "width":230,
    "crew":10
  }
}
```

### Alerts

#### Creating an alert

##### Request

```
POST /api/v1/en/alerts HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE

{
  "alert":{
    "latitude":"54.025369",
    "longitude":"21.765876",
    "alert_type":"BAD_WEATHER_CONDITIONS",
    "additional_info":"Zawody Giżycko 2014"
  }
}
```

##### Sucessful response

```
# STATUS: 201 Created
{
  "alert":{
    "id":15,
    "latitude":"54.025369",
    "longitude:"21.765876",
    "alert_type":"BAD_WEATHER_CONDITIONS",
    "additional_info":"Zawody Giżycko 2014",
    "created_at":"2014-10-19T16:06:25.422Z",
    "user_id":22,
    "credibility":0,
    "active":true,
    "user_vote":0,
  }
}
```

##### Possible responses

| Status | Description                                   |
| ------ | --------------------------------------------- |
| 201    | Everything went fine. New alert is created    |
| 401    | Access token is invalid or revoked.           |
| 460    | Region id is invalid                          |

#### Geting single alert

##### Request

```
GET /api/v1/en/alerts/:ID/ HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Response

```
# STATUS: 200 OK
{
  "alert":{
    "id":15,
    "latitude":"54.025369",
    "longitude:"21.765876",
    "alert_type":"BAD_WEATHER_CONDITIONS",
    "additional_info":"Zawody Giżycko 2014",
    "created_at":"2014-10-19T16:06:25.422Z",
    "user_id":22,
    "credibility":0,
    "active":true,
    "user_vote:0
  }
}
```

##### Possible status codes

| Status | Description                                                |
| ------ | ---------------------------------------------------------- |
| 200    | Everything went fine.                                      |
| 401    | Access token is invalid or revoked.                        |
| 404    | Alert with given ID is not present                         |
| 422    | Provided data is invalid                                   |
| 460    | Region ID is invalid                                       |

#### Confirming/canceling alert

##### Confirming

```
POST /api/v1/en/alerts/:ID/confirmations HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Canceling

```
DELETE /api/v1/en/alerts/15/confirmations HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Response

```
# STATUS: 200 OK
{
  "alert":{
    "id":15,
    "latitude":"54.025369",
    "longitude:"21.765876",
    "alert_type":"BAD_WEATHER_CONDITIONS",
    "additional_info":"Zawody Giżycko 2014",
    "created_at":"2014-10-19T16:06:25.422Z",
    "user_id":22,
    "credibility":-5,
    "active":false,
    "user_vote":1
  }
}
```

##### Possible status codes

| Status | Description                                                |
| ------ | ---------------------------------------------------------- |
| 200    | Everything went fine.                                      |
| 401    | Access token is invalid or revoked.                        |
| 403    | You're alert owner - you can't confirm/deny your own alert |
| 404    | Alert with given ID is not present                         |
| 460    | Region ID is invalid                                       |

##### Credibility rules

You can make only one action per alert - confirming it means +1 to alert creadibilty. If you change your mind and decline alert your +1 is changed for -1.

##### User vote values
+ <code>0</code> - user has not confirmed/denied this alert yet
+ <code>1</code> - user has confirmed this alert
+ <code>-1</code> - user has denied this alert

##### Archiving task
Each alert is archived due to <code>check_tasks</code> rake task after 4 hours with no activity. Task is launched every hour.

#### Allowed alert types

+ <code>BAD_WEATHER_CONDITIONS</code>
+ <code>CLOSED_AREA</code>
+ <code>YACHT_FAILURE</code>

### Ports
| Field                                       | Type     | Comments                                  |
| ------------------------------------------- | -------- | ----------------------------------------- |
| <code>id</code>                             | Integer  |                                           |
| <code>region_id</code>                      | Integer  |                                           |
| <code>name</code>                           | String   |                                           |
| <code>longitude</code>                      | Decimal  | Default: <code>0.0</code>                 |
| <code>latitude</code>                       | Decimal  | Default: <code>0.0</code>                 |
| <code>created_at</code>                     | DateTime |                                           |
| <code>updated_at</code>                     | DateTime |                                           |
| <code>photo_url</code>                      | String   |                                           |
| <code>website</code>                        | String   |                                           |
| <code>city</code>                           | String   |                                           |
| <code>street</code>                         | String   |                                           |
| <code>telephone</code>                      | String   | Default: <code>true</code>                |
| <code>additional_info</code>                | String   | Default: <code>true</code>                |
| <code>currency</code>                       | String   | Default: <code>EUR</code>                 |
| <code>spots</code>                          | Integer  | Default: <code>true</code>                |
| <code>depth</code>                          | Integer  | In centemeters, Default: <code>100</code> |
| <code>price_per_person</code>               | String   | Default: <code>0.0</code>                 |
| <code>price_power_connection</code>         | String   | Default: <code>0.0</code>                 |
| <code>price_wc</code>                       | String   | Default: <code>0.0</code>                 |
| <code>price_shower</code>                   | String   | Default: <code>0.0</code>                 |
| <code>price_washbasin</code>                | String   | Default: <code>0.0</code>                 |
| <code>price_dishes</code>                   | String   | Default: <code>0.0</code>                 |
| <code>price_parking</code>                  | String   | Default: <code>0.0</code>                 |
| <code>price_wifi</code>                     | String   | Default: <code>0.0</code>                 |
| <code>price_washing_machine</code>          | String   | Default: <code>0.0</code>                 |
| <code>price_emptying_chemical_toilet</code> | String   | Default: <code>0.0</code>                 |
| <code>has_power_connection</code>           | Boolean  | Default: <code>true</code>                |
| <code>has_wc</code>                         | Boolean  | Default: <code>true</code>                |
| <code>has_shower</code>                     | Boolean  | Default: <code>true</code>                |
| <code>has_parking</code>                    | Boolean  | Default: <code>true</code>                |
| <code>has_washbasin</code>                  | Boolean  | Default: <code>true</code>                |
| <code>has_dishes</code>                     | Boolean  | Default: <code>true</code>                |
| <code>has_wifi</code>                       | Boolean  | Default: <code>true</code>                |
| <code>has_slip</code>                       | Boolean  | Default: <code>false</code>               |
| <code>has_washing_machine</code>            | Boolean  | Default: <code>true</code>                |
| <code>has_fuel_station</code>               | Boolean  | Default: <code>false</code>               |
| <code>has_parking</code>                    | Boolean  | Default: <code>true</code>                |

Each port can have different prices depending on boat size. Sailhero handles it by **Yacht Size Range Price** model:

| Field                   | Type     | Comments      |
| ----------------------- | -------- | ------------- |
| <code>id</code>         | Integer  |               |
| <code>port_id</code>    | Integer  |               |
| <code>min_length</code> | Integer  | In centemetrs |
| <code>max_length</code> | Integer  | In centemetrs |
| <code>max_width</code>  | Integer  | In centemetrs |
| <code>created_at</code> | DateTime |               |
| <code>updated_at</code> | DateTime |               |
| <code>price</code>      | Float    |               |

#### Getting all ports

##### Request

```
GET /api/v1/en/map/ports HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Sucessful response

```
# STATUS: 200 OK
{
  "ports":[
    {
      "id": 17,
      "name": "Sztynort",
      "latitude": "54.130976",
      "longitude": "21.682389",
      "website": "http://www.tiga-yacht.com.pl/",
      "city": "Wegorzewo",
      "street": "Sztynort 11",
      "photo_url": null,
      "telephone": "+48 87 427 51 80",
      "additional_info": "Showers for 10 minutes, restaurant available",
      "spots": 120,
      "depth": 100,
      "has_power_connection": true,
      "has_wc": true,
      "has_shower": true,
      "has_washbasin": true,
      "has_dishes": true,
      "has_wifi": true,
      "has_parking": true,
      "has_slip": false,
      "has_washing_machine": true,
      "has_fuel_station": true,
      "has_emptying_chemical_toilet": true,
      "price_per_person": 15,
      "price_power_connection": 0,
      "price_wc": 0,
      "price_shower": 15,
      "price_washbasin": 0,
      "price_dishes": 0,
      "price_wifi": 0,
      "price_washing_machine": 15,
      "price_emptying_chemical_toilet": 0,
      "price_parking": 0,
      "currency": "EUR"
    },
    ...
  ]
}
```

##### Possible responses

| Status | Description                         |
| ------ | ----------------------------------- |
| 200    | Everything went fine                |
| 401    | Access token is invalid or revoked. |
| 460    | Region id is invalid                |

#### Getting single port

##### Request

```
GET /api/v1/en/map/ports/:id HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Sucessful response

```
# STATUS: 200 OK
{
  "port": {
    "id": 17,
    "name": "Sztynort",
    "latitude": "54.130976",
    "longitude": "21.682389",
    "website": "http://www.tiga-yacht.com.pl/",
    "city": "Wegorzewo",
    "street": "Sztynort 11",
    "photo_url": null,
    "telephone": "+48 87 427 51 80",
    "additional_info": "Showers for 10 minutes, restaurant available",
    "spots": 120,
    "depth": 100,
    "has_power_connection": true,
    "has_wc": true,
    "has_shower": true,
    "has_washbasin": true,
    "has_dishes": true,
    "has_wifi": true,
    "has_parking": true,
    "has_slip": false,
    "has_washing_machine": true,
    "has_fuel_station": true,
    "has_emptying_chemical_toilet": true,
    "price_per_person": 15,
    "price_power_connection": 0,
    "price_wc": 0,
    "price_shower": 15,
    "price_washbasin": 0,
    "price_dishes": 0,
    "price_wifi": 0,
    "price_washing_machine": 15,
    "price_emptying_chemical_toilet": 0,
    "price_parking": 0,
    "currency": "EUR"
  }
}
```

##### Possible responses

| Status | Description                                                 |
| ------ | ----------------------------------------------------------- |
| 200    | Everything went fine                                        |
| 401    | Access token is invalid or revoked.                         |
| 404    | Port with given id was not found or is in different region. |
| 460    | Region id is invalid                                        |

#### Calculating port cost

##### Request

```
GET /api/v1/en/map/ports/:id/calculate HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Sucessful response

```
# STATUS: 200 OK
{
  "port": {
    "cost": 135,
    "currency": "EUR",
    "included": [
      {
        name: "wc",
        price: 0
      },
      ...
    ],
    "optional": [
      {
        name: "power_connection",
        price: 10
      },
      ...
    ]
    "additional_info": "Lorem ipsum dolores..."
  }
}
```

##### Possible responses

| Status | Description                                                 |
| ------ | ----------------------------------------------------------- |
| 200    | Everything went fine                                        |
| 401    | Access token is invalid or revoked.                         |
| 404    | Port with given id was not found or is in different region. |
| 460    | Region id is invalid                                        |
| 464    | There is no spot for your yacht (is too big or too small).  |
| 465    | You're trying to calculate port cost with no yacht.         |

### Routes
| Field                                       | Type     | Comments                                  |
| ------------------------------------------- | -------- | ----------------------------------------- |
| <code>id</code>                             | Integer  |                                           |
| <code>name</code>                           | String   |                                           |
| <code>created_at</code>                     | DateTime |                                           |
| <code>updated_at</code>                     | DateTime |                                           |

Each route can have mutiple **pins**:

| Field                   | Type     |
| ----------------------- | -------- |
| <code>id</code>         | Integer  |
| <code>route_id</code>   | Integer  |
| <code>longitude</code>  | Decimal  |
| <code>latitude</code>   | Decimal  |
| <code>created_at</code> | DateTime |
| <code>updated_at</code> | DateTime |

#### Getting all routes

##### Request

```
GET /api/v1/en/map/routes HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Sucessful response

```
# STATUS: 200 OK
{
  "routes":[
    {
      "id": 17,
      "name": "Wielki Szlak Mazurski",
      "pins":[
        {
          "latitude": "54.130976",
          "longitude": "21.682389"
        },
      ]
    },
    ...
  ]
}
```

##### Possible responses

| Status | Description                         |
| ------ | ----------------------------------- |
| 200    | Everything went fine                |
| 401    | Access token is invalid or revoked. |
| 460    | Region id is invalid                |

#### Getting single route

##### Request

```
GET /api/v1/en/map/routes/:id HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
Authorization: Bearer YOUR_ACCESS_TOKEN
Longitude: YOUR_LONGITUDE
Latitude: YOUR_LATITUDE
```

##### Sucessful response

```
# STATUS: 200 OK
{
  "route":{
    "id": 17,
    "name": "Wielki Szlak Mazurski",
    "pins":[
      {
        "latitude": "54.130976",
        "longitude": "21.682389"
      },
      ...
    ]
  }
}
```

##### Possible responses

| Status | Description                         |
| ------ | ----------------------------------- |
| 200    | Everything went fine                |
| 401    | Access token is invalid or revoked. |
| 404    | Route not found.                    |
| 460    | Region id is invalid                |

## Custom API status codes

| Status | Description                                                    |
| ------ | -------------------------------------------------------------- |
| 460    | Region ID is invalid.                                          |
| 461    | User has already created yacht.                                |
| 462    | Forever alone. You're trying to become a friend with yourself. |
| 463    | You're trying to become a friend with nil.                     |
| 464    | There is no spot for your yacht (is too big or too small)      |
| 465    | You're trying to calculate port cost with no yacht.            |
