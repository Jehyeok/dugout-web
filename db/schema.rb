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

ActiveRecord::Schema.define(version: 20150208081934) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: true do |t|
    t.integer  "like",             default: 0
    t.integer  "dislike",          default: 0
    t.integer  "count",            default: 0
    t.string   "title"
    t.text     "content",                       null: false
    t.integer  "user_like_ids",    default: [],              array: true
    t.integer  "user_dislike_ids", default: [],              array: true
    t.integer  "level",            default: 0
    t.string   "image_names",      default: [],              array: true
    t.integer  "user_id",                       null: false
    t.integer  "group_id",                      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["group_id"], name: "index_boards_on_group_id", using: :btree
  add_index "boards", ["user_id"], name: "index_boards_on_user_id", using: :btree

  create_table "comments", force: true do |t|
    t.text     "content",                  null: false
    t.integer  "depth",       default: 0
    t.integer  "user_id",                  null: false
    t.integer  "board_id",                 null: false
    t.integer  "parent_id"
    t.string   "image_names", default: [],              array: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "number",     null: false
    t.string   "name",       null: false
    t.integer  "rank",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "password",               null: false
    t.string   "email",                  null: false
    t.string   "nick_name",              null: false
    t.string   "ip"
    t.string   "gcm_reg_id"
    t.integer  "group_id",   default: 1, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["group_id"], name: "index_users_on_group_id", using: :btree

end
