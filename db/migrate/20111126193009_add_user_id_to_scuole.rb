class AddUserIdToScuole < ActiveRecord::Migration
  def change
    add_column :scuole, :user_id, :integer
    add_index :scuole, :user_id
    add_index :scuole, :nome
  end
end
