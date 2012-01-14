class CreateIndirizzi < ActiveRecord::Migration
  def change
    create_table :indirizzi do |t|
      
      t.string   :destinatario
      t.string   :indirizzo
      t.string   :cap
      t.string   :citta
      t.string   :provincia
      t.string   :tipo
      t.integer  :indirizzable_id
      t.string   :indirizzable_type
      t.boolean  :gmaps
      t.float    :latitude
      t.float    :longitude
      
      t.timestamps
    end
  end
end
