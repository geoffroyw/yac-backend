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

ActiveRecord::Schema.define(version: 20150709201402) do

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
    t.string   "name",        limit: 255,   null: false
    t.integer  "capacity",    limit: 4,     null: false
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.datetime "deleted_at"
  end

  add_index "apartment_apartments", ["deleted_at"], name: "index_apartment_apartments_on_deleted_at", using: :btree

  create_table "apartment_equipment", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "countries", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "iso",        limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: :cascade do |t|
    t.string   "first_name", limit: 255, null: false
    t.string   "last_name",  limit: 255, null: false
    t.string   "email",      limit: 255
    t.string   "phone",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pricing_periods", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "pricing_prices", force: :cascade do |t|
    t.integer  "period_id",       limit: 4
    t.integer  "number_of_night", limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.integer  "amount_cents",    limit: 4,   default: 0,     null: false
    t.string   "amount_currency", limit: 255, default: "EUR", null: false
  end

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
  end

  add_index "rentals", ["apartment_id"], name: "index_rentals_on_apartment_id", using: :btree
  add_index "rentals", ["customer_id"], name: "index_rentals_on_customer_id", using: :btree
  add_index "rentals", ["end_date"], name: "index_rentals_on_end_date", using: :btree
  add_index "rentals", ["start_date"], name: "index_rentals_on_start_date", using: :btree

end
