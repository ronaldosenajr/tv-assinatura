# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_13_010921) do
  create_table "additional_services", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "package_additional_services", force: :cascade do |t|
    t.integer "package_id", null: false
    t.integer "additional_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_service_id"], name: "index_package_additional_services_on_additional_service_id"
    t.index ["package_id"], name: "index_package_additional_services_on_package_id"
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.integer "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id"], name: "index_packages_on_plan_id"
  end

  create_table "plans", force: :cascade do |t|
    t.string "name"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "subscription_additional_services", force: :cascade do |t|
    t.integer "subscription_id", null: false
    t.integer "additional_service_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["additional_service_id"], name: "idx_on_additional_service_id_305e585373"
    t.index ["subscription_id"], name: "index_subscription_additional_services_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer "client_id", null: false
    t.integer "plan_id", null: false
    t.integer "package_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_subscriptions_on_client_id"
    t.index ["package_id"], name: "index_subscriptions_on_package_id"
    t.index ["plan_id"], name: "index_subscriptions_on_plan_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "package_additional_services", "additional_services"
  add_foreign_key "package_additional_services", "packages"
  add_foreign_key "packages", "plans"
  add_foreign_key "sessions", "users"
  add_foreign_key "subscription_additional_services", "additional_services"
  add_foreign_key "subscription_additional_services", "subscriptions"
  add_foreign_key "subscriptions", "clients"
  add_foreign_key "subscriptions", "packages"
  add_foreign_key "subscriptions", "plans"
end
