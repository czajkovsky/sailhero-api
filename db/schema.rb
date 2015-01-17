# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150117145102) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "alert_confirmations", force: true do |t|
    t.integer  "user_id"
    t.boolean  "up"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "alert_id"
  end

  create_table "alerts", force: true do |t|
    t.string   "alert_type"
    t.text     "additional_info"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                                                 null: false
    t.integer  "credibility",                              default: 0
    t.decimal  "latitude",        precision: 10, scale: 6
    t.decimal  "longitude",       precision: 10, scale: 6
    t.boolean  "active",                                   default: true
    t.integer  "region_id",                                               null: false
  end

  create_table "devices", force: true do |t|
    t.string   "device_type"
    t.string   "name"
    t.integer  "token_id",    null: false
    t.string   "key"
    t.integer  "user_id",     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendships", force: true do |t|
    t.integer  "user_id"
    t.integer  "friend_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.integer  "user_id"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
  end

  create_table "oauth_access_grants", force: true do |t|
    t.integer  "resource_owner_id", null: false
    t.integer  "application_id",    null: false
    t.string   "token",             null: false
    t.integer  "expires_in",        null: false
    t.text     "redirect_uri",      null: false
    t.datetime "created_at",        null: false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id"
    t.string   "token",             null: false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        null: false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: true do |t|
    t.string   "name",                      null: false
    t.string   "uid",                       null: false
    t.string   "secret",                    null: false
    t.text     "redirect_uri",              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "scopes",       default: "", null: false
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "pins", force: true do |t|
    t.integer "route_id",  null: false
    t.decimal "latitude"
    t.decimal "longitude"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ports", force: true do |t|
    t.string   "name"
    t.decimal  "longitude",                      precision: 10, scale: 6, default: 0.0
    t.decimal  "latitude",                       precision: 10, scale: 6, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "website"
    t.string   "city"
    t.string   "street"
    t.string   "telephone"
    t.string   "additional_info"
    t.integer  "spots"
    t.integer  "depth",                                                   default: 100
    t.float    "price_per_person",                                        default: 0.0
    t.float    "price_power_connection",                                  default: 0.0
    t.float    "price_wc",                                                default: 0.0
    t.float    "price_shower",                                            default: 0.0
    t.float    "price_washbasin",                                         default: 0.0
    t.float    "price_dishes",                                            default: 0.0
    t.float    "price_wifi",                                              default: 0.0
    t.float    "price_washing_machine",                                   default: 0.0
    t.float    "price_emptying_chemical_toilet",                          default: 0.0
    t.boolean  "has_power_connection",                                    default: true
    t.boolean  "has_wc",                                                  default: true
    t.boolean  "has_shower",                                              default: true
    t.boolean  "has_washbasin",                                           default: true
    t.boolean  "has_dishes",                                              default: true
    t.boolean  "has_wifi",                                                default: true
    t.boolean  "has_parking",                                             default: true
    t.boolean  "has_slip",                                                default: false
    t.boolean  "has_washing_machine",                                     default: true
    t.boolean  "has_fuel_station",                                        default: false
    t.boolean  "has_emptying_chemical_toilet",                            default: true
    t.float    "price_parking",                                           default: 0.0
    t.string   "currency",                                                default: "EUR"
    t.string   "photo_url"
    t.integer  "region_id"
  end

  create_table "regions", force: true do |t|
    t.string "full_name"
    t.string "code_name"
  end

  create_table "routes", force: true do |t|
    t.string   "name"
    t.integer  "region_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                                        default: "",    null: false
    t.string   "password_hash",                                default: "",    null: false
    t.string   "password_salt",                                default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",                                         default: ""
    t.string   "surname",                                      default: ""
    t.boolean  "active",                                       default: false
    t.decimal  "latitude",            precision: 10, scale: 6
    t.decimal  "longitude",           precision: 10, scale: 6
    t.datetime "position_updated_at"
    t.integer  "region_id"
    t.string   "avatar"
    t.string   "activation_token"
    t.boolean  "share_position",                               default: true
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  create_table "yacht_size_range_prices", force: true do |t|
    t.integer  "min_length"
    t.integer  "max_length"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "port_id"
    t.integer  "max_width",  default: 100
  end

  create_table "yachts", force: true do |t|
    t.integer "length",  default: 700
    t.integer "width",   default: 200
    t.integer "crew"
    t.string  "name"
    t.integer "user_id"
  end

end
