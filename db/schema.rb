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

ActiveRecord::Schema.define(version: 2023_07_30_064639) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", id: :integer, limit: 2, default: -> { "nextval('comment_id_seq'::regclass)" }, force: :cascade do |t|
    t.integer "player_id", limit: 2, null: false
    t.integer "race_id", limit: 2, null: false
    t.text "comment_text"
  end

  create_table "games", id: :integer, limit: 2, default: nil, force: :cascade do |t|
    t.text "name", null: false
    t.integer "release_year", limit: 2
    t.text "publisher"
    t.text "developer"
    t.text "genre"
    t.string "description"
    t.string "has_moon"
    t.string "has_cali"
    t.index ["id"], name: "game_id_unique", unique: true
  end

  create_table "glossaries", force: :cascade do |t|
    t.string "name"
    t.string "definition"
    t.string "author"
  end

  create_table "placements", primary_key: ["race_id", "player_id"], force: :cascade do |t|
    t.integer "race_id", limit: 2, null: false
    t.integer "player_id", limit: 2, null: false
    t.integer "placement", limit: 2, null: false
    t.integer "time"
  end

  create_table "players", id: :integer, limit: 2, default: -> { "nextval('player_id_seq'::regclass)" }, force: :cascade do |t|
    t.text "name", null: false
    t.text "stream"
  end

  create_table "races", id: :integer, limit: 2, default: -> { "nextval('race_id_seq'::regclass)" }, force: :cascade do |t|
    t.date "date"
    t.integer "game_id", limit: 2, null: false
    t.text "url"
    t.string "description"
    t.string "goal"
    t.integer "duration"
  end

  create_table "terms", force: :cascade do |t|
    t.string "name"
    t.string "definition"
    t.string "author"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "twitch_nickname"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
  end

  add_foreign_key "comments", "players", name: "comment_player_id_fk"
  add_foreign_key "comments", "races", name: "comment_race_id_fk"
  add_foreign_key "placements", "players", name: "placements_player_id_fk"
  add_foreign_key "placements", "races", name: "placements_race_id_fk"
  add_foreign_key "races", "games", name: "race_game_id_fk"
end
