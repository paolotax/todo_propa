class AddStatusToFatture < ActiveRecord::Migration
  def change
    add_column :fatture, :status, :string

  end
end
