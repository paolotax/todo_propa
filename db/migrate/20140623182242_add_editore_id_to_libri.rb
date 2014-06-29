class AddEditoreIdToLibri < ActiveRecord::Migration
  def change

    add_column :libri, :editore_id, :integer

    add_index :libri, :editore_id
  end
end
