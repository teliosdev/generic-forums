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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120707060233) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "position"
    t.text     "sub"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "ropes_count", :default => 0
    t.integer  "posts_count", :default => 0
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.integer  "remote_id"
    t.string   "permissions"
    t.integer  "group_id"
    t.string   "type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "posts", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "rope_id"
    t.decimal  "points",     :precision => 16, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                 :null => false
    t.datetime "updated_at",                                                 :null => false
  end

  add_index "posts", ["rope_id"], :name => "index_posts_on_rope_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "ropes", :force => true do |t|
    t.string   "title"
    t.integer  "board_id"
    t.integer  "user_id"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "posts_count", :default => 0
  end

  add_index "ropes", ["board_id"], :name => "index_ropes_on_board_id"
  add_index "ropes", ["user_id"], :name => "index_ropes_on_user_id"

  create_table "user_groups", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "avatar"
    t.decimal  "points",              :default => 0.0
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "crypted_password",    :default => "",  :null => false
    t.string   "password_salt",       :default => "",  :null => false
    t.string   "persistence_token",   :default => "",  :null => false
    t.string   "single_access_token", :default => "",  :null => false
    t.string   "perishable_token",    :default => "",  :null => false
    t.integer  "login_count",         :default => 0,   :null => false
    t.integer  "failed_login_count",  :default => 0,   :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "posts_count",         :default => 0
    t.integer  "ropes_count",         :default => 0
  end

end
