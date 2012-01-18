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

ActiveRecord::Schema.define(:version => 20120118150247) do

  create_table "appunti", :force => true do |t|
    t.string   "destinatario"
    t.text     "note"
    t.string   "stato",          :default => "",  :null => false
    t.date     "scadenza"
    t.integer  "cliente_id"
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

  add_index "appunti", ["cliente_id"], :name => "index_appunti_on_scuola_id"
  add_index "appunti", ["stato"], :name => "index_appunti_on_stato"
  add_index "appunti", ["user_id"], :name => "index_appunti_on_user_id"

  create_table "clienti", :force => true do |t|
    t.string   "nome"
    t.string   "citta"
    t.string   "provincia"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "cliente_tipo"
    t.string   "codice_fiscale"
    t.string   "partita_iva"
  end

  add_index "clienti", ["nome"], :name => "index_scuole_on_nome"
  add_index "clienti", ["user_id"], :name => "index_scuole_on_user_id"

  create_table "fatture", :force => true do |t|
    t.integer  "numero"
    t.date     "data"
    t.integer  "scuola_id"
    t.integer  "user_id"
    t.integer  "causale_id"
    t.string   "condizioni_pagamento"
    t.string   "string"
    t.boolean  "pagata"
    t.integer  "totale_copie",                                       :default => 0
    t.integer  "integer",                                            :default => 0
    t.decimal  "importo_fattura",      :precision => 9, :scale => 2
    t.decimal  "totale_iva",           :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "spese",                :precision => 9, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fatture", ["causale_id"], :name => "index_fatture_on_causale_id"
  add_index "fatture", ["scuola_id"], :name => "index_fatture_on_scuola_id"
  add_index "fatture", ["user_id", "causale_id", "numero"], :name => "index_fatture_per_utente_and_causale", :unique => true
  add_index "fatture", ["user_id"], :name => "index_fatture_on_user_id"

  create_table "indirizzi", :force => true do |t|
    t.string   "destinatario"
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "citta"
    t.string   "provincia"
    t.string   "tipo"
    t.integer  "indirizzable_id"
    t.string   "indirizzable_type"
    t.boolean  "gmaps"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "libri", :force => true do |t|
    t.string   "autore"
    t.string   "titolo"
    t.string   "sigla"
    t.decimal  "prezzo_copertina",   :precision => 8, :scale => 2
    t.decimal  "prezzo_consigliato", :precision => 8, :scale => 2
    t.decimal  "coefficente",        :precision => 2, :scale => 1
    t.string   "cm"
    t.string   "ean"
    t.string   "type"
    t.integer  "materia_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image"
  end

  add_index "libri", ["titolo"], :name => "index_libri_on_titolo"

  create_table "righe", :force => true do |t|
    t.integer  "libro_id"
    t.integer  "quantita"
    t.decimal  "prezzo_unitario", :precision => 9, :scale => 3
    t.decimal  "sconto",          :precision => 5, :scale => 2, :default => 0.0
    t.boolean  "consegnato"
    t.boolean  "pagato"
    t.integer  "appunto_id"
    t.integer  "fattura_id"
    t.integer  "magazzino_id"
    t.integer  "causale_id"
    t.integer  "movimento"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "righe", ["appunto_id"], :name => "index_righe_on_appunto_id"
  add_index "righe", ["causale_id"], :name => "index_righe_on_causale_id"
  add_index "righe", ["fattura_id"], :name => "index_righe_on_fattura_id"
  add_index "righe", ["libro_id"], :name => "index_righe_on_libro_id"

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
    t.string   "avatar"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
