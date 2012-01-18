class RenameScuoleToClienti < ActiveRecord::Migration

  def change
    rename_table :scuole, :clienti
  end

end
