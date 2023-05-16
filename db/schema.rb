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

ActiveRecord::Schema[7.0].define(version: 2023_02_20_034145) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "entries", force: :cascade do |t|
    t.text "text_content", default: ""
    t.boolean "editable"
    t.bigint "prompt_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prompt_id"], name: "index_entries_on_prompt_id"
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "journals", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.text "description", default: ""
    t.string "visibility", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "journals_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "journal_id", null: false
    t.string "user_roles", default: [], array: true
  end

  create_table "prompts", force: :cascade do |t|
    t.string "title"
    t.boolean "editable"
    t.date "scheduled_date"
    t.bigint "journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "recurring_prompt_id"
    t.index ["journal_id"], name: "index_prompts_on_journal_id"
    t.index ["recurring_prompt_id"], name: "index_prompts_on_recurring_prompt_id"
  end

  create_table "recurring_prompts", force: :cascade do |t|
    t.string "title"
    t.boolean "is_active"
    t.boolean "is_time_important"
    t.datetime "start_date"
    t.string "schedule_type", limit: 4, default: ""
    t.integer "schedule_interval"
    t.bigint "journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["journal_id"], name: "index_recurring_prompts_on_journal_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "user_name", default: "", null: false
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "entries", "prompts"
  add_foreign_key "entries", "users"
  add_foreign_key "prompts", "journals"
  add_foreign_key "prompts", "recurring_prompts"
  add_foreign_key "recurring_prompts", "journals"
end
