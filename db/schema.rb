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

ActiveRecord::Schema.define(version: 20160708033507) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "skus", force: :cascade do |t|
    t.integer  "supplier_id"
    t.float    "price"
    t.string   "property_1"
    t.string   "property_2"
    t.string   "property_3"
    t.string   "property_4"
    t.string   "property_5"
    t.string   "property_6"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "skus", ["supplier_id"], name: "index_skus_on_supplier_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
