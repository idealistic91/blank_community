# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_02_15_192646) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "communities", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "owner_id"
    t.string "server_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "communities_users", id: false, force: :cascade do |t|
    t.bigint "community_id"
    t.bigint "user_id"
    t.index ["community_id"], name: "index_communities_users_on_community_id"
    t.index ["user_id"], name: "index_communities_users_on_user_id"
  end

  create_table "discord_roles", force: :cascade do |t|
    t.string "name"
    t.string "discord_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "community_id"
    t.index ["community_id"], name: "index_discord_roles_on_community_id"
  end

  create_table "event_games", force: :cascade do |t|
    t.bigint "game_id"
    t.bigint "event_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_games_on_event_id"
    t.index ["game_id"], name: "index_event_games_on_game_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.date "date"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "creator_id"
    t.integer "slots"
    t.datetime "start_at"
    t.datetime "ends_at"
    t.bigint "community_id"
    t.string "state"
    t.string "channel_id"
    t.index ["community_id"], name: "index_events_on_community_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "igdb_id"
  end

  create_table "hosting_events", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_hosting_events_on_event_id"
    t.index ["member_id"], name: "index_hosting_events_on_member_id"
  end

  create_table "member_discord_roles", force: :cascade do |t|
    t.bigint "member_id"
    t.bigint "discord_role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_role_id"], name: "index_member_discord_roles_on_discord_role_id"
    t.index ["member_id"], name: "index_member_discord_roles_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.string "nickname"
    t.bigint "user_id"
    t.bigint "community_id"
    t.index ["community_id"], name: "index_members_on_community_id"
    t.index ["user_id"], name: "index_members_on_user_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "member_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_participants_on_event_id"
    t.index ["member_id"], name: "index_participants_on_member_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "longitude"
    t.string "latitude"
    t.text "name"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "role_assignments", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "discord_role_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["discord_role_id"], name: "index_role_assignments_on_discord_role_id"
    t.index ["role_id"], name: "index_role_assignments_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "key"
  end

  create_table "roles_tables", force: :cascade do |t|
    t.string "name"
  end

  create_table "settings", force: :cascade do |t|
    t.string "main_channel"
    t.boolean "public", default: true
    t.bigint "community_id"
    t.index ["community_id"], name: "index_settings_on_community_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "discord_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "discord_roles", "communities"
  add_foreign_key "events", "communities"
  add_foreign_key "members", "communities"
end
