SailHero API
============
[![Code Climate](https://codeclimate.com/github/czajkovsky/sailhero-api.png)](https://codeclimate.com/github/czajkovsky/sailhero-api)
[![TravisCI](https://travis-ci.org/czajkovsky/sailhero-api.svg)](https://travis-ci.org/czajkovsky/sailhero-api)

API for apps dedicated to sailors.

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

#### Request
```json
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
```json
# STATUS: 201 Created
{
  "user":{
    "id":999,
    "created_at":"2014-09-13T09:57:21.402Z",
    "email":"email@example.com"
  }
}
```

