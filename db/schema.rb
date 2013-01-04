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

ActiveRecord::Schema.define(:version => 20121220211935) do

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

  create_table "events", :force => true do |t|
    t.string   "remote_type"
    t.integer  "remote_id"
    t.string   "type"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "events", ["remote_id", "remote_type"], :name => "remote_id_type_index"
  add_index "events", ["type"], :name => "index_events_on_type"
  add_index "events", ["user_id"], :name => "index_events_on_user_id"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "avatar_size"
    t.string   "title"
    t.string   "name_color"
  end

  create_table "impressions", :force => true do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], :name => "controlleraction_ip_index"
  add_index "impressions", ["controller_name", "action_name", "request_hash"], :name => "controlleraction_request_index"
  add_index "impressions", ["controller_name", "action_name", "session_hash"], :name => "controlleraction_session_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], :name => "poly_ip_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], :name => "poly_request_index"
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], :name => "poly_session_index"
  add_index "impressions", ["user_id"], :name => "index_impressions_on_user_id"

  create_table "permissions", :force => true do |t|
    t.integer  "remote_id"
    t.string   "action"
    t.integer  "group_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.boolean  "negate",      :default => false
    t.string   "remote_type"
  end

  add_index "permissions", ["remote_id"], :name => "index_permissions_on_remote_id"

  create_table "posts", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "rope_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "format",     :default => "markdown"
    t.integer  "parent_id"
    t.text     "options"
  end

  add_index "posts", ["parent_id"], :name => "index_posts_on_parent_id"
  add_index "posts", ["rope_id"], :name => "index_posts_on_rope_id"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "ropes", :force => true do |t|
    t.string   "title"
    t.integer  "board_id"
    t.integer  "user_id"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.integer  "posts_count",       :default => 0
    t.boolean  "is_ghost",          :default => false
    t.text     "ghost_data"
    t.integer  "impressions_count", :default => 0
  end

  add_index "ropes", ["board_id"], :name => "index_ropes_on_board_id"
  add_index "ropes", ["user_id"], :name => "index_ropes_on_user_id"

  create_table "ropes_tags", :force => true do |t|
    t.integer "rope_id"
    t.integer "tag_id"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "user_groups", :force => true do |t|
    t.integer "user_id"
    t.integer "group_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",               :default => "", :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "posts_count",            :default => 0
    t.integer  "ropes_count",            :default => 0
    t.text     "options"
    t.integer  "primary_group_id"
    t.string   "title"
  end

  add_index "users", ["authentication_token"], :name => "index_users_on_authentication_token", :unique => true
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
