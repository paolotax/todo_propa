class RenameScuolaIdFatture < ActiveRecord::Migration
  def up
    rename_column :fatture, :scuola_id, :cliente_id
  end

  def down
    rename_column :fatture, :cliente_id, :scuola_id
  end
end
