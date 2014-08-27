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

ActiveRecord::Schema.define(:version => 20140709212016) do

  create_table "adozioni", :force => true do |t|
    t.integer  "classe_id"
    t.integer  "libro_id"
    t.integer  "materia_id"
    t.integer  "nr_copie",   :default => 0
    t.integer  "nr_sezioni", :default => 0
    t.string   "anno"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "kit_1"
    t.string   "kit_2"
  end

  add_index "adozioni", ["classe_id"], :name => "index_adozioni_on_classe_id"
  add_index "adozioni", ["libro_id"], :name => "index_adozioni_on_libro_id"
  add_index "adozioni", ["materia_id"], :name => "index_adozioni_on_materia_id"

  create_table "appunti", :force => true do |t|
    t.string   "destinatario"
    t.text     "note"
    t.string   "stato",                         :default => "",  :null => false
    t.date     "scadenza"
    t.integer  "cliente_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "telefono"
    t.string   "email"
    t.integer  "totale_copie",                  :default => 0
    t.float    "totale_importo",                :default => 0.0
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "uuid",           :limit => nil
    t.datetime "deleted_at"
    t.datetime "completed_at"
    t.string   "nota"
    t.integer  "score"
  end

  add_index "appunti", ["cliente_id"], :name => "index_appunti_on_cliente_id"
  add_index "appunti", ["stato"], :name => "index_appunti_on_stato"
  add_index "appunti", ["user_id"], :name => "index_appunti_on_user_id"

  create_table "appunto_events", :force => true do |t|
    t.integer  "appunto_id"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "appunto_events", ["appunto_id"], :name => "index_appunto_events_on_appunto_id"

  create_table "classi", :force => true do |t|
    t.integer  "classe"
    t.string   "sezione"
    t.integer  "nr_alunni",  :default => 0
    t.integer  "cliente_id"
    t.string   "spec_id"
    t.string   "sper_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.string   "insegnanti"
    t.text     "note"
    t.string   "libro_1"
    t.string   "libro_2"
    t.string   "libro_3"
    t.string   "libro_4"
    t.string   "anno"
  end

  add_index "classi", ["cliente_id", "classe", "sezione"], :name => "index_classi_on_scuola_id_and_classe_and_sezione", :unique => true
  add_index "classi", ["cliente_id"], :name => "index_classi_on_cliente_id"

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
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "ancestry"
    t.string   "slug"
    t.hstore   "properties"
    t.string   "uuid",            :limit => nil
    t.datetime "deleted_at"
  end

  add_index "clienti", ["cliente_tipo"], :name => "index_clienti_on_cliente_tipo"
  add_index "clienti", ["properties"], :name => "clienti_properties"
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

  create_table "editori", :force => true do |t|
    t.string   "nome"
    t.string   "gruppo"
    t.string   "codice"
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
    t.string   "status"
  end

  add_index "fatture", ["causale_id"], :name => "index_fatture_on_causale_id"
  add_index "fatture", ["cliente_id"], :name => "index_fatture_on_scuola_id"
  add_index "fatture", ["user_id"], :name => "index_fatture_on_user_id"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type", :unique => true
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

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
    t.string   "slug"
    t.string   "iva"
    t.integer  "classe"
    t.integer  "editore_id"
    t.integer  "next_id"
  end

  add_index "libri", ["editore_id"], :name => "index_libri_on_editore_id"
  add_index "libri", ["materia_id"], :name => "index_libri_on_materia_id"
  add_index "libri", ["settore"], :name => "index_libri_on_settore"
  add_index "libri", ["slug"], :name => "index_libri_on_slug"
  add_index "libri", ["titolo"], :name => "index_libri_on_titolo"

  create_table "libro_connections", :id => false, :force => true do |t|
    t.integer "libro_parent_id", :null => false
    t.integer "libro_child_id",  :null => false
  end

  add_index "libro_connections", ["libro_child_id"], :name => "index_libro_connections_on_libro_child_id"
  add_index "libro_connections", ["libro_parent_id"], :name => "index_libro_connections_on_libro_parent_id"

  create_table "materie", :force => true do |t|
    t.string  "materia"
    t.string  "gruppo"
    t.integer "ordine"
    t.decimal "prezzo_copertina",   :precision => 8, :scale => 2
    t.decimal "prezzo_consigliato", :precision => 8, :scale => 2
  end

  create_table "oauth_access_grants", :force => true do |t|
    t.integer  "resource_owner_id", :null => false
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.integer  "expires_in",        :null => false
    t.string   "redirect_uri",      :null => false
    t.datetime "created_at",        :null => false
    t.datetime "revoked_at"
    t.string   "scopes"
  end

  add_index "oauth_access_grants", ["token"], :name => "index_oauth_access_grants_on_token", :unique => true

  create_table "oauth_access_tokens", :force => true do |t|
    t.integer  "resource_owner_id"
    t.integer  "application_id",    :null => false
    t.string   "token",             :null => false
    t.string   "refresh_token"
    t.integer  "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at",        :null => false
    t.string   "scopes"
  end

  add_index "oauth_access_tokens", ["refresh_token"], :name => "index_oauth_access_tokens_on_refresh_token", :unique => true
  add_index "oauth_access_tokens", ["resource_owner_id"], :name => "index_oauth_access_tokens_on_resource_owner_id"
  add_index "oauth_access_tokens", ["token"], :name => "index_oauth_access_tokens_on_token", :unique => true

  create_table "oauth_applications", :force => true do |t|
    t.string   "name",         :null => false
    t.string   "uid",          :null => false
    t.string   "secret",       :null => false
    t.string   "redirect_uri", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "oauth_applications", ["uid"], :name => "index_oauth_applications_on_uid", :unique => true

  create_table "propa2014s", :force => true do |t|
    t.integer  "cliente_id"
    t.date     "data_visita"
    t.date     "data_ritiro"
    t.date     "data_interclasse"
    t.date     "data_collegio"
    t.string   "kit_123"
    t.integer  "nr_123"
    t.string   "kit_45"
    t.integer  "nr_45"
    t.string   "kit_123_ing"
    t.integer  "nr_45_ing"
    t.string   "kit_123_rel"
    t.integer  "nr_123_rel"
    t.string   "kit_45_rel"
    t.integer  "nr_45_rel"
    t.string   "vac_1"
    t.string   "vac_2"
    t.string   "vac_3"
    t.string   "vac_4"
    t.string   "vac_5"
    t.integer  "nr_vac_1"
    t.integer  "nr_vac_2"
    t.integer  "nr_vac_3"
    t.integer  "nr_vac_4"
    t.integer  "nr_vac_5"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.date     "data_vacanze"
  end

  add_index "propa2014s", ["cliente_id"], :name => "index_propa2014s_on_cliente_id"

  create_table "righe", :force => true do |t|
    t.integer  "libro_id"
    t.integer  "quantita"
    t.decimal  "prezzo_unitario",                :precision => 9, :scale => 3
    t.decimal  "sconto",                         :precision => 5, :scale => 2, :default => 0.0
    t.boolean  "consegnato"
    t.boolean  "pagato"
    t.integer  "appunto_id"
    t.integer  "fattura_id"
    t.integer  "magazzino_id"
    t.integer  "causale_id"
    t.integer  "movimento"
    t.datetime "created_at",                                                                    :null => false
    t.datetime "updated_at",                                                                    :null => false
    t.string   "uuid",            :limit => nil
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

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

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
    t.hstore   "properties"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["properties"], :name => "users_properties"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "visita_appunti", :force => true do |t|
    t.integer  "visita_id"
    t.integer  "appunto_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "visita_appunti", ["visita_id", "appunto_id"], :name => "index_visita_appunti_on_visita_id_and_appunto_id"

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

  create_table "will_filter_filters", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.text     "data"
    t.integer  "user_id"
    t.string   "model_class_name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "will_filter_filters", ["user_id"], :name => "index_will_filter_filters_on_user_id"

end
