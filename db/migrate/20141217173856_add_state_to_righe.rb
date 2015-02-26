class AddStateToRighe < ActiveRecord::Migration

  def up

    change_column :appunti, :totale_importo, :decimal, :precision => 9, :scale => 2, :default => 0.0
    
    add_column :righe, :importo,  :decimal, :precision => 9, :scale => 2, :default => 0.0
    add_column :righe, :state,    :string
    add_column :righe, :position, :integer
    
    add_column :righe, :pagata_il,      :date
    add_column :righe, :consegnata_il,  :date
    
    add_index  :righe, [:id, :position]
    
    say "eseguo rake youpropa:crea_documenti"
    Rake::Task['youpropa:create_documenti'].invoke

    say "eseguo rake youpropa:set_riga_state"
    Rake::Task['youpropa:set_riga_state'].invoke    
  end


  def down
    remove_column :righe, :importo
    remove_column :righe, :state
    remove_column :righe, :position

    add_column :righe, :pagato_il
    add_column :righe, :consegnato_il
 

    remove_index :righe, [:id, :position]
  end


end
