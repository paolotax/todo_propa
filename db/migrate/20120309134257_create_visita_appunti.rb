class CreateVisitaAppunti < ActiveRecord::Migration
  def change
    create_table :visita_appunti do |t|
      t.integer :visita_id
      t.integer :appunto_id

      t.timestamps
    end
    
    add_index :visita_appunti, [:visita_id, :appunto_id], :uniq => true
    
    # drop_table :visita_righe
  end


end
