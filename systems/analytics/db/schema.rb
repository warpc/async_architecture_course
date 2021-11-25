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

ActiveRecord::Schema.define(version: 2021_11_24_201722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "auth_identities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "uid"
    t.string "provider", null: false
    t.string "login", null: false
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_auth_identities_on_user_id"
  end

  create_table "billing_cycles", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.date "date", null: false
    t.decimal "company_profit_amount", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_billing_cycles_on_public_id", unique: true
  end

  create_table "daily_statistics", force: :cascade do |t|
    t.date "date", null: false
    t.decimal "company_profit_amount", default: "0.0", null: false
    t.uuid "most_expensive_task_public_id"
    t.decimal "most_expensive_task_price", default: "0.0", null: false
    t.integer "users_with_negative_balance_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_daily_statistics_on_date", unique: true
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.string "title", default: "", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_tasks_on_public_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.uuid "user_public_id"
    t.uuid "task_public_id"
    t.string "reason"
    t.decimal "amount", default: "0.0"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_transactions_on_public_id", unique: true
    t.index ["task_public_id"], name: "index_transactions_on_task_public_id"
    t.index ["user_public_id"], name: "index_transactions_on_user_public_id"
  end

  create_table "users", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.string "full_name"
    t.string "role"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
  end

  add_foreign_key "auth_identities", "users"
end
