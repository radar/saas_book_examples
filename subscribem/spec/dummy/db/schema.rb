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

ActiveRecord::Schema.define(version: 20140830020346) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "subscribem_accounts", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "owner_id"
    t.string   "subdomain"
    t.integer  "plan_id"
    t.string   "braintree_subscription_id"
  end

  add_index "subscribem_accounts", ["subdomain"], name: "index_subscribem_accounts_on_subdomain", using: :btree

  create_table "subscribem_members", force: true do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribem_plans", force: true do |t|
    t.string   "name"
    t.float    "price"
    t.string   "braintree_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribem_users", force: true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", force: true do |t|
    t.string   "name"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
