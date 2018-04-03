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

ActiveRecord::Schema.define(version: 20180403094858) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cities", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "department_id"
    t.bigint "division_id"
    t.bigint "sector_city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_cities_on_department_id"
    t.index ["division_id"], name: "index_cities_on_division_id"
    t.index ["sector_city_id"], name: "index_cities_on_sector_city_id"
  end

  create_table "departments", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "divisions", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_divisions_on_department_id"
  end

  create_table "offices", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "department_id"
    t.bigint "division_id"
    t.bigint "sector_city_id"
    t.bigint "city_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_offices_on_city_id"
    t.index ["department_id"], name: "index_offices_on_department_id"
    t.index ["division_id"], name: "index_offices_on_division_id"
    t.index ["sector_city_id"], name: "index_offices_on_sector_city_id"
  end

  create_table "privileges", force: :cascade do |t|
    t.string "action"
    t.integer "weight"
    t.text "resource"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role_id"
    t.index ["role_id"], name: "index_privileges_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sector_cities", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "department_id"
    t.bigint "division_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department_id"], name: "index_sector_cities_on_department_id"
    t.index ["division_id"], name: "index_sector_cities_on_division_id"
  end

  create_table "user_roles", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "expired_at"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.json "object"
    t.json "object_changes"
    t.datetime "created_at"
    t.string "ip"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "cities", "departments"
  add_foreign_key "cities", "divisions"
  add_foreign_key "cities", "sector_cities"
  add_foreign_key "divisions", "departments"
  add_foreign_key "offices", "cities"
  add_foreign_key "offices", "departments"
  add_foreign_key "offices", "divisions"
  add_foreign_key "offices", "sector_cities"
  add_foreign_key "sector_cities", "departments"
  add_foreign_key "sector_cities", "divisions"
end
