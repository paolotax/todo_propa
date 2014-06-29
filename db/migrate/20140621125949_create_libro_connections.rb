class CreateLibroConnections < ActiveRecord::Migration
  
  def change 
    create_table :libro_connections, force: true, id: false do |t|

      t.integer  :libro_parent_id, null: false
      t.integer  :libro_child_id,  null: false

    end

    add_index :libro_connections, :libro_parent_id
    add_index :libro_connections, :libro_child_id
    
  end
end
