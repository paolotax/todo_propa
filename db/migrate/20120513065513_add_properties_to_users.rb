class AddPropertiesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :properties, :hstore

  end
end
