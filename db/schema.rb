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

ActiveRecord::Schema.define(version: 20150713192053) do

  create_table "addresses", force: :cascade do |t|
    t.string   "address",     limit: 255, null: false
    t.string   "address2",    limit: 255
    t.string   "postal_code", limit: 255, null: false
    t.string   "city",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id",  limit: 4,   null: false
    t.integer  "customer_id", limit: 4
  end

  create_table "apartment_apartment_equipments", force: :cascade do |t|
    t.integer  "apartment_id", limit: 4
    t.integer  "equipment_id", limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "apartment_apartment_equipments", ["apartment_id"], name: "index_apartment_apartment_equipments_on_apartment_id", using: :btree
  add_index "apartment_apartment_equipments", ["equipment_id"], name: "index_apartment_apartment_equipments_on_equipment_id", using: :btree

  create_table "apartment_apartments", force: :cascade do |t|
    t.string   "name",            limit: 255,   null: false
    t.integer  "capacity",        limit: 4,     null: false
    t.text     "description",     limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.datetime "deleted_at"
    t.integer  "organization_id", limit: 4
  end

  add_index "apartment_apartments", ["deleted_at"], name: "index_apartment_apartments_on_deleted_at", using: :btree
  add_index "apartment_apartments", ["organization_id"], name: "index_apartment_apartments_on_organization_id", using: :btree

  create_table "apartment_equipment", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.text     "description",     limit: 65535
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "organization_id", limit: 4
  end

  add_index "apartment_equipment", ["organization_id"], name: "index_apartment_equipment_on_organization_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "iso",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name",      limit: 255, null: false
    t.string   "last_name",       limit: 255, null: false
    t.string   "email",           limit: 255
    t.string   "phone",           limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "organization_id", limit: 4
  end

  add_index "customers", ["organization_id"], name: "index_customers_on_organization_id", using: :btree

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4,     null: false
    t.integer  "application_id",    limit: 4,     null: false
    t.string   "token",             limit: 255,   null: false
    t.integer  "expires_in",        limit: 4,     null: false
    t.text     "redirect_uri",      limit: 65535, null: false
    t.datetime "created_at",                      null: false
    t.datetime "revoked_at"
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_grants", ["token"], name: "index_oauth_access_grants_on_token", unique: true, using: :btree

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer  "resource_owner_id", limit: 4
    t.integer  "application_id",    limit: 4
    t.string   "token",             limit: 255, null: false
    t.string   "refresh_token",     limit: 255
    t.integer  "expires_in",        limit: 4
    t.datetime "revoked_at"
    t.datetime "created_at",                    null: false
    t.string   "scopes",            limit: 255
  end

  add_index "oauth_access_tokens", ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true, using: :btree
  add_index "oauth_access_tokens", ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id", using: :btree
  add_index "oauth_access_tokens", ["token"], name: "index_oauth_access_tokens_on_token", unique: true, using: :btree

  create_table "oauth_applications", force: :cascade do |t|
    t.string   "name",         limit: 255,                null: false
    t.string   "uid",          limit: 255,                null: false
    t.string   "secret",       limit: 255,                null: false
    t.text     "redirect_uri", limit: 65535,              null: false
    t.string   "scopes",       limit: 255,   default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "oauth_applications", ["uid"], name: "index_oauth_applications_on_uid", unique: true, using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "admin_id",   limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "organizations", ["admin_id"], name: "index_organizations_on_admin_id", using: :btree

  create_table "pricing_apartment_prices", force: :cascade do |t|
    t.integer  "apartment_id", limit: 4
    t.integer  "price_id",     limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "pricing_apartment_prices", ["apartment_id"], name: "index_pricing_apartment_prices_on_apartment_id", using: :btree
  add_index "pricing_apartment_prices", ["price_id"], name: "index_pricing_apartment_prices_on_price_id", using: :btree

  create_table "pricing_periods", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "organization_id", limit: 4
  end

  add_index "pricing_periods", ["organization_id"], name: "index_pricing_periods_on_organization_id", using: :btree

  create_table "pricing_prices", force: :cascade do |t|
    t.integer  "period_id",       limit: 4
    t.integer  "number_of_night", limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "amount_cents",    limit: 4,   default: 0,     null: false
    t.string   "amount_currency", limit: 255, default: "EUR", null: false
    t.integer  "organization_id", limit: 4
  end

  add_index "pricing_prices", ["organization_id"], name: "index_pricing_prices_on_organization_id", using: :btree
  add_index "pricing_prices", ["period_id"], name: "index_pricing_prices_on_period_id", using: :btree

  create_table "rentals", force: :cascade do |t|
    t.integer  "customer_id",        limit: 4
    t.integer  "apartment_id",       limit: 4
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "number_of_adult",    limit: 4
    t.integer  "number_of_children", limit: 4
    t.string   "state",              limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "organization_id",    limit: 4
  end

  add_index "rentals", ["apartment_id"], name: "index_rentals_on_apartment_id", using: :btree
  add_index "rentals", ["customer_id"], name: "index_rentals_on_customer_id", using: :btree
  add_index "rentals", ["end_date"], name: "index_rentals_on_end_date", using: :btree
  add_index "rentals", ["organization_id"], name: "index_rentals_on_organization_id", using: :btree
  add_index "rentals", ["start_date"], name: "index_rentals_on_start_date", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.integer  "failed_attempts",        limit: 4,   default: 0,  null: false
    t.string   "unlock_token",           limit: 255
    t.datetime "locked_at"
    t.string   "username",               limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "organization_id",        limit: 4
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["organization_id"], name: "index_users_on_organization_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
