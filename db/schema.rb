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

ActiveRecord::Schema.define(:version => 20120909113259) do

  create_table "keys", :force => true do |t|
    t.string   "key"
    t.string   "comment"
    t.integer  "value_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.string   "format"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "languages_users", :id => false, :force => true do |t|
    t.integer "language_id"
    t.integer "user_id"
  end

  add_index "languages_users", ["language_id", "user_id"], :name => "index_languages_users_on_language_id_and_user_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.integer  "language_id"
    t.integer  "repository_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "projects_users", :id => false, :force => true do |t|
    t.integer "project_id"
    t.integer "user_id"
  end

  add_index "projects_users", ["project_id", "user_id"], :name => "index_projects_users_on_project_id_and_user_id"

  create_table "repositories", :force => true do |t|
    t.string   "sshKey"
    t.string   "name"
    t.string   "address"
    t.integer  "repositoryType_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "repository_types", :force => true do |t|
    t.integer  "type"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "source_types", :force => true do |t|
    t.string   "name"
    t.integer  "type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "sources", :force => true do |t|
    t.string   "filePath"
    t.integer  "project_id"
    t.integer  "sourceType_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "translations", :force => true do |t|
    t.integer  "project_id"
    t.integer  "language_id"
    t.integer  "value_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "translations_users", :id => false, :force => true do |t|
    t.integer "translation_id"
    t.integer "user_id"
  end

  add_index "translations_users", ["translation_id", "user_id"], :name => "index_translations_users_on_translation_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "firstName"
    t.string   "lastName"
    t.string   "password"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "values", :force => true do |t|
    t.string   "value"
    t.boolean  "isTranslated"
    t.boolean  "isStared"
    t.integer  "key_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end