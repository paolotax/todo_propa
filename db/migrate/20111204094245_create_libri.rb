class CreateLibri < ActiveRecord::Migration
  def change
    create_table :libri do |t|
      
      t.string   :autore
      t.string   :titolo
      t.string   :sigla
      t.decimal  :prezzo_copertina,   :precision => 8, :scale => 2
      t.decimal  :prezzo_consigliato, :precision => 8, :scale => 2
      t.decimal  :coefficente,        :precision => 2, :scale => 1
      t.string   :cm
      t.string   :ean  
      t.string   :type
      t.integer  :materia_id
      
      t.timestamps
    end
    
    add_index :libri, :titolo
  end
end
