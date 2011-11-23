class ChangeAppuntiNote < ActiveRecord::Migration
  def up
    change_column :appunti, :note, :text
  end

  def down
    change_column :appunti, :note, :string
  end
end
