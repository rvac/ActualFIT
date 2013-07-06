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

ActiveRecord::Schema.define(:version => 20130601101515) do

  create_table "artifacts", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.integer  "inspection_id"
    t.binary   "file",          :limit => 52428800
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "filename"
    t.string   "content_type"
    t.integer  "user_id"
  end

  add_index "artifacts", ["inspection_id"], :name => "index_artifacts_on_inspection_id"

  create_table "campaigns", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "chat_messages", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "inspection_id"
  end

  add_index "chat_messages", ["user_id", "created_at"], :name => "index_chat_messages_on_user_id_and_created_at"

  create_table "inspections", :force => true do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "inspection_team_id"
    t.integer  "campaign_id"
    t.string   "status"
  end

  add_index "inspections", ["name"], :name => "index_inspections_on_name"

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "inspection_id"
    t.string   "role"
  end

  create_table "remarks", :force => true do |t|
    t.string   "location"
    t.string   "content"
    t.integer  "user_id"
    t.integer  "inspection_id"
    t.string   "remark_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "artifact_id"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "remember_token"
    t.integer  "inspection_team_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
