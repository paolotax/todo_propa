class AddStateToRighe < ActiveRecord::Migration

  def up

    change_column :appunti, :totale_importo, :decimal, :precision => 9, :scale => 2, :default => 0.0
    
    add_column :righe, :importo,  :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :righe, :state,    :string
    add_column :righe, :position, :integer
    
    add_index  :righe, [:id, :position]
  
    say "eseguire rake youpropa:set_riga_state"

  end


  def down
    remove_column :righe, :importo
    remove_column :righe, :state
    remove_column :righe, :position

    remove_index :righe, [:id, :position]
  end


end
