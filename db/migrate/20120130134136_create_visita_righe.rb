class CreateVisitaRighe < ActiveRecord::Migration
  def change
    create_table :visita_righe do |t|
      
      t.integer :visita_id
      
      t.integer :visitable_id
      t.string :visitable_type
    end

    add_index :visita_righe, :visita_id
    add_index :visita_righe, [:visitable_id, :visitable_type]
  end
end
