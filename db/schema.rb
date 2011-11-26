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

ActiveRecord::Schema.define(:version => 20111126070612) do

  create_table "appunti", :force => true do |t|
    t.string   "destinatario"
    t.text     "note"
    t.string   "stato",          :default => "",  :null => false
    t.date     "scadenza"
    t.integer  "scuola_id"
    t.integer  "position"
    t.string   "telefono"
    t.string   "email"
    t.integer  "user_id"
    t.integer  "totale_copie",   :default => 0
    t.float    "totale_importo", :default => 0.0
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "appunti", ["scuola_id"], :name => "index_appunti_on_scuola_id"
  add_index "appunti", ["stato"], :name => "index_appunti_on_stato"
  add_index "appunti", ["user_id"], :name => "index_appunti_on_user_id"

  create_table "scuole", :force => true do |t|
    t.string   "nome"
    t.string   "citta"
    t.string   "provincia"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "searches", :force => true do |t|
    t.string   "title"
    t.string   "model"
    t.string   "keywords"
    t.string   "destinatario"
    t.string   "note"
    t.string   "stato"
    t.string   "scuola"
    t.string   "citta"
    t.string   "provincia"
    t.string   "zona"
    t.string   "tag_list"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "username"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
