class CreateVisitaAppunti < ActiveRecord::Migration
  def change
    create_table :visita_appunti do |t|
      t.integer :visita_id
      t.integer :appunto_id

      t.timestamps
    end
  end
  
  def up 
    drop_table :visita_righe
  end
  
  
end
