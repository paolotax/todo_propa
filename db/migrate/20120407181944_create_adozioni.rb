class CreateAdozioni < ActiveRecord::Migration
  def change
    create_table :adozioni do |t|
      
      t.integer  :classe_id
      t.integer  :libro_id
      t.integer  :materia_id
      t.integer  :nr_copie,   default: 0
      t.integer  :nr_sezioni, default: 0
      t.string   :anno

      t.timestamps
    end
    
    add_index :adozioni, :classe_id
    add_index :adozioni, :libro_id
    add_index :adozioni, :materia_id
    
  end
end
