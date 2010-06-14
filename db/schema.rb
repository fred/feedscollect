# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100614062335) do

  create_table "categories", :force => true do |t|
    t.string   "title"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "permalink"
    t.boolean  "default_home", :default => false
    t.integer  "owner_id"
  end

  create_table "categories_users", :id => false, :force => true do |t|
    t.integer "category_id"
    t.integer "user_id"
  end

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "author"
    t.text     "summary"
    t.text     "content"
    t.datetime "published"
    t.integer  "feed_site_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "unread",       :default => true
  end

  create_table "feed_sites", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.string   "etag"
    t.text     "description"
    t.integer  "category_id"
    t.integer  "feed_type"
    t.datetime "last_modified"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "site_url"
    t.string   "logo_url"
    t.integer  "sort_order",          :default => 200
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                                    :null => false
    t.string   "email",                                    :null => false
    t.string   "crypted_password",                         :null => false
    t.string   "password_salt",                            :null => false
    t.string   "persistence_token",                        :null => false
    t.string   "single_access_token",                      :null => false
    t.string   "perishable_token",                         :null => false
    t.integer  "login_count",           :default => 0,     :null => false
    t.integer  "failed_login_count",    :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",                 :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "full_name"
    t.integer  "feeds_per_page"
    t.float    "font_size",             :default => 0.7
    t.integer  "home_page_category_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["login"], :name => "index_users_on_login"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"

end
