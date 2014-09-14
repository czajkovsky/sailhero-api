SailHero API
============
[![Code Climate](https://codeclimate.com/github/czajkovsky/sailhero-api.png)](https://codeclimate.com/github/czajkovsky/sailhero-api)
[![TravisCI](https://travis-ci.org/czajkovsky/sailhero-api.svg)](https://travis-ci.org/czajkovsky/sailhero-api)
[![Test Coverage](https://codeclimate.com/github/czajkovsky/sailhero-api/badges/coverage.svg)](https://codeclimate.com/github/czajkovsky/sailhero-api)

API for apps dedicated to sailors.


## Host

```
api.sail-hero.dev/v1/en
```

+ **Subdomain** -  API by default is accessible from subdomain - <code>api.BASE_URL.com</code>
+ **Versioning** follows base url in HOST name (current version is <code>v1</code>).
+ **I18n** - currently only english version is variable (<code>en</code>).

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
POST /v1/en/users HTTP/1.1
Host: api.sail-hero.dev
Content-Type: application/json

{
  "user":{
    "email":"email@example.com",
    "password":"password_example",
    "password_confirmation":"password1",
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
    "email":"email@example.com"
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
POST /v1/en/yachts?access_token=YOUR_ACCESS_TOKEN HTTP/1.1
Host: api.sail-hero.dev
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

