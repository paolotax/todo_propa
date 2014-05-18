class AddNotaToAppunti < ActiveRecord::Migration
  def change
    add_column :appunti, :nota, :string

    add_column :appunti, :score, :integer

  end
end
