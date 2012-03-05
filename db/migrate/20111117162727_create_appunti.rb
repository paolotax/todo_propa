class CreateAppunti < ActiveRecord::Migration
  def change
    create_table :appunti do |t|

      t.string   :destinatario
      t.text     :note
      t.string   :stato, :default => "",  :null => false
      t.date     :scadenza
      t.integer  :cliente_id
      t.integer  :user_id

      t.integer  :position
      t.string   :telefono
      t.string   :email

      t.integer  :totale_copie,   :default => 0
      t.float    :totale_importo, :default => 0.0

      t.float    :latitude
      t.float    :longitude
      t.timestamps
    end

    add_index :appunti, :cliente_id
    add_index :appunti, :user_id
    add_index :appunti, :stato
  end
end
