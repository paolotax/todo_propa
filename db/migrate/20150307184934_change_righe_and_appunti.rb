class ChangeRigheAndAppunti < ActiveRecord::Migration

  def up

    remove_column :righe, :fattura_id
    remove_column :righe, :consegnato
    remove_column :righe, :pagato
    remove_column :righe, :causale_id

    add_column    :righe, :documento_id, :integer

    add_column :appunti, :righe_count, :integer, :null => false, :default => 0


    say "eseguo rake youpropa:reimposta_id_documento"
    Rake::Task['youpropa:reimposta_id_documento'].invoke
  end

  def down

    add_column :righe, :fattura_id
    add_column :righe, :consegnato
    add_column :righe, :pagato
    add_column :righe, :causale_id

    remove_column :righe, :documento_id    
    remove_column :appunti, :data
    remove_column :appunti, :righe_count

  end


end
