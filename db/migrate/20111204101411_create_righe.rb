class CreateRighe < ActiveRecord::Migration
  def change
    create_table :righe do |t|

      t.integer  :libro_id
      t.integer  :quantita
      t.decimal  :prezzo_unitario, :precision => 9, :scale => 3
      t.decimal  :sconto,          :precision => 5, :scale => 2, :default => 0.0
      t.boolean  :consegnato
      t.boolean  :pagato
      t.integer  :appunto_id
      t.integer  :fattura_id
      t.integer  :magazzino_id
      t.integer  :causale_id
      t.integer  :movimento      
      t.timestamps
    end
    
    add_index :righe, :fattura_id
    add_index :righe, :appunto_id
    add_index :righe, :causale_id
    add_index :righe, :libro_id
  end
end
