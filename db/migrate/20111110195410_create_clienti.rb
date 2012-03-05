class CreateClienti < ActiveRecord::Migration
  def change
    create_table :clienti do |t|
      
      t.string :titolo
      t.string :cliente_tipo
      t.string :nome
      t.string :cognome
      t.string :ragione_sociale
      t.string :abbr
      t.string :codice_fiscale
      t.string :partita_iva
      t.string :indirizzo
      t.string :cap
      t.string :frazione
      t.string :comune
      t.string :provincia
      t.string :telefono
      t.string :telefono_2
      t.string :fax
      t.string :cellulare
      t.string :email
      t.string :url
      t.boolean :gmaps
      t.float :longitude
      t.float :latitude
      
      t.integer :user_id

      t.timestamps
    end
    
    add_index :clienti, :user_id
    add_index :clienti, :cliente_tipo
  end
end
