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
1. Install Postgresal and create role
2. Run <code>rake db:create</code> & <code>rake db:migrate</code>

##### 3. Setup local domain
API requires <code>api</code> subdomain, so url should look more/less like <code>http://api.sail-hero.dev</code>

##### 4. Run server
<code>rails s</code>

## Models

### User
| Field                      | Type    | Comments |
| -------------------------- | ------- | -------- |
| <code>id</code>            | Integer |          |
| <code>email</code>         | String  |          |
| <code>password_hash</code> | String  |          |
| <code>password_salt</code> | String  |          |
| <code>created_at</code>    | String  |          |
| <code>updated_at</code>    | String  |          |
| <code>name</code>          | String  |          |
| <code>surname</code>       | String  |          |

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
    "email":"email@example.com",
    "yacht":null
  }
}
```

#### Authenticated user profile

##### Request
```
GET /api/v1/en/users/me?access_token=YOUR_ACCESS_TOKEN HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json
```

##### Response
```
# STATUS: 200 OK
{
  "user":{
    "id":999,
    "created_at":"2014-09-13T09:57:21.402Z",
    "email":"email@example.com",
    "yacht":{
      id: 997,
      name:"Your Yacht Name",
      length: 780,
      width: 230
    }
  }
}
```

### Yacht

Each user has one yacht which is used for port cost calculations.

| Field                | Type    | Comments              |
| -------------------- | ------- | --------------------- |
| <code>id</code>      | Integer |                       |
| <code>name</code>    | String  |                       |
| <code>length</code>  | Integer | In centimeters        |
| <code>width</code>   | Integer | In centimeters        |
| <code>crew</code>    | Integer | Crew members on board |
| <code>user_id</code> | Integer |                       |

#### Creating yacht

##### Request
```
POST /api/v1/en/yachts?access_token=YOUR_ACCESS_TOKEN HTTP/1.1
Host: sail-hero.dev
Content-Type: application/json

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
TO-DO
```

