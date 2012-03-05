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

ActiveRecord::Schema.define(:version => 20120305201856) do

  create_table "appunti", :force => true do |t|
    t.string   "destinatario"
    t.text     "note"
    t.string   "stato",          :default => "",  :null => false
    t.date     "scadenza"
    t.integer  "cliente_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "telefono"
    t.string   "email"
    t.integer  "totale_copie",   :default => 0
    t.float    "totale_importo", :default => 0.0
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "appunti", ["cliente_id"], :name => "index_appunti_on_cliente_id"
  add_index "appunti", ["stato"], :name => "index_appunti_on_stato"
  add_index "appunti", ["user_id"], :name => "index_appunti_on_user_id"

  create_table "clienti", :force => true do |t|
    t.string   "titolo"
    t.string   "cliente_tipo"
    t.string   "nome"
    t.string   "cognome"
    t.string   "ragione_sociale"
    t.string   "abbr"
    t.string   "codice_fiscale"
    t.string   "partita_iva"
    t.string   "indirizzo"
    t.string   "cap"
    t.string   "frazione"
    t.string   "comune"
    t.string   "provincia"
    t.string   "telefono"
    t.string   "telefono_2"
    t.string   "fax"
    t.string   "cellulare"
    t.string   "email"
    t.string   "url"
    t.boolean  "gmaps"
    t.float    "longitude"
    t.float    "latitude"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "ancestry"
    t.string   "slug"
  end

  add_index "clienti", ["cliente_tipo"], :name => "index_clienti_on_cliente_tipo"
  add_index "clienti", ["user_id"], :name => "index_clienti_on_user_id"

  create_table "comuni", :force => true do |t|
    t.string   "istat"
    t.string   "comune"
    t.string   "provincia"
    t.string   "regione"
    t.string   "prefisso"
    t.string   "cap"
    t.string   "codfisco"
    t.integer  "abitanti"
    t.string   "link"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "fatture", :force => true do |t|
    t.integer  "numero"
    t.date     "data"
    t.integer  "cliente_id"
    t.integer  "user_id"
    t.integer  "causale_id"
    t.string   "condizioni_pagamento"
    t.boolean  "pagata"
    t.integer  "totale_copie",                                       :default => 0
    t.decimal  "importo_fattura",      :precision => 9, :scale => 2
    t.decimal  "totale_iva",           :precision => 9, :scale => 2, :default => 0.0
    t.decimal  "spese",                :precision => 9, :scale => 2, :default => 0.0
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
    t.string   "slug"
  end

  add_index "fatture", ["causale_id"], :name => "index_fatture_on_causale_id"
  add_index "fatture", ["cliente_id"], :name => "index_fatture_on_scuola_id"
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
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
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
    t.string   "old_id"
    t.string   "settore"
    t.integer  "materia_id"
    t.string   "image"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "libri", ["materia_id"], :name => "index_libri_on_materia_id"
  add_index "libri", ["settore"], :name => "index_libri_on_settore"
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
    t.datetime "created_at",                                                     :null => false
    t.datetime "updated_at",                                                     :null => false
  end

  add_index "righe", ["appunto_id"], :name => "index_righe_on_appunto_id"
  add_index "righe", ["causale_id"], :name => "index_righe_on_causale_id"
  add_index "righe", ["fattura_id"], :name => "index_righe_on_fattura_id"
  add_index "righe", ["libro_id"], :name => "index_righe_on_libro_id"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "username"
    t.string   "avatar"
    t.string   "telefono"
    t.string   "web_site"
    t.string   "nome_completo"
    t.string   "codice_fiscale"
    t.string   "partita_iva"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "visita_righe", :force => true do |t|
    t.integer "visita_id"
    t.integer "visitable_id"
    t.string  "visitable_type"
  end

  add_index "visita_righe", ["visita_id"], :name => "index_visita_righe_on_visita_id"
  add_index "visita_righe", ["visitable_id", "visitable_type"], :name => "index_visita_righe_on_visitable_id_and_visitable_type"

  create_table "visite", :force => true do |t|
    t.integer  "cliente_id"
    t.string   "titolo"
    t.datetime "start"
    t.datetime "end"
    t.boolean  "all_day"
    t.boolean  "baule"
    t.string   "scopo"
    t.integer  "giro_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "visite", ["cliente_id"], :name => "index_visite_on_cliente_id"

end
