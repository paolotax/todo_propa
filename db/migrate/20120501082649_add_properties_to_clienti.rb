class AddPropertiesToClienti < ActiveRecord::Migration
  def change
    add_column :clienti, :properties, :hstore

  end
end
