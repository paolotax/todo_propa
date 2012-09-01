class AddClasseToLibri < ActiveRecord::Migration
  def change
    add_column :libri, :classe, :integer

  end
end
