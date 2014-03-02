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

ActiveRecord::Schema.define(version: 20140302094302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "repos", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "repos", ["name"], name: "index_repos_on_name", unique: true, using: :btree

  create_table "stars", force: true do |t|
    t.integer  "user_id"
    t.integer  "repo_id"
    t.boolean  "unstarred",  default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stars_tags", id: false, force: true do |t|
    t.integer "tag_id",  null: false
    t.integer "star_id", null: false
  end

  add_index "stars_tags", ["star_id"], name: "index_stars_tags_on_star_id", using: :btree
  add_index "stars_tags", ["tag_id"], name: "index_stars_tags_on_tag_id", using: :btree

  create_table "tags", force: true do |t|
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["slug"], name: "index_tags_on_slug", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.string   "uid"
    t.string   "token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
