class FixClienteId < ActiveRecord::Migration
  def change
    rename_column :appunti, :scuola_id, :cliente_id
  end
end
