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

ActiveRecord::Schema.define(version: 2021_11_21_104246) do

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
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.date "date", null: false
    t.decimal "company_profit_amount", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["date"], name: "index_billing_cycles_on_date", unique: true
    t.index ["public_id"], name: "index_billing_cycles_on_public_id", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.decimal "amount", default: "0.0", null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "billing_cycle_id", null: false
    t.index ["billing_cycle_id"], name: "index_payments_on_billing_cycle_id"
    t.index ["public_id"], name: "index_payments_on_public_id", unique: true
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.string "title", default: "", null: false
    t.text "description"
    t.decimal "assigned_fee", default: "0.0", null: false
    t.decimal "completed_amount", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_tasks_on_public_id", unique: true
  end

  create_table "transactions", force: :cascade do |t|
    t.uuid "public_id", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "user_id", null: false
    t.bigint "task_id"
    t.string "reason", null: false
    t.decimal "amount", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_transactions_on_public_id", unique: true
    t.index ["task_id"], name: "index_transactions_on_task_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.uuid "public_id", null: false
    t.string "full_name"
    t.string "role"
    t.string "email"
    t.decimal "balance", default: "0.0", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["public_id"], name: "index_users_on_public_id", unique: true
  end

  add_foreign_key "auth_identities", "users"
  add_foreign_key "payments", "billing_cycles"
  add_foreign_key "payments", "users"
  add_foreign_key "transactions", "tasks"
  add_foreign_key "transactions", "users"
end
