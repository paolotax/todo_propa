class CreateDocumenti < ActiveRecord::Migration
  

  def up
    create_table :documenti do |t|
      
      t.integer :numero
      t.date    :data
      t.text    :note
      t.integer :cliente_id
      t.integer :causale_id
      t.integer :user_id
      
      t.string  :condizioni_pagamento
      t.integer :totale_copie,                                  :default => 0
      
      t.decimal :totale_importo,  :precision => 9, :scale => 2, :default => 0.0
      t.decimal :totale_iva,      :precision => 9, :scale => 2, :default => 0.0
      t.decimal :spese,           :precision => 9, :scale => 2, :default => 0.0
      
      t.string  :state
      t.string  :slug

      t.date    :payed_at
      
      t.timestamps
    end

    add_index :documenti, :cliente_id
    add_index :documenti, :user_id
    add_index :documenti, :causale_id

    create_table :documenti_righe do |t|
      t.integer :documento_id
      t.integer :riga_id
    end


  end

  def down

    drop_table :documenti
    drop_table :documenti_righe
  end

end
