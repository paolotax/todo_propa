class CreateFatture < ActiveRecord::Migration
  def change
    create_table :fatture do |t|
      t.integer :numero
      t.date    :data
      t.integer :scuola_id
      t.integer :user_id
      t.integer :causale_id
      t.string  :condizioni_pagamento
      t.boolean :pagata
      t.integer :totale_copie,    :integer, :default => 0
      t.decimal :importo_fattura, :precision => 9, :scale => 2
      t.decimal :totale_iva,      :precision => 9, :scale => 2, :default => 0.0
      t.decimal :spese,           :precision => 9, :scale => 2, :default => 0.0
      
      t.timestamps
    end
    
    add_index :fatture, :scuola_id
    add_index :fatture, :user_id
    add_index :fatture, :causale_id
    add_index :fatture, [:user_id, :causale_id, :numero], { :name => 'index_fatture_per_utente_and_causale', :unique => true}
  end
end
