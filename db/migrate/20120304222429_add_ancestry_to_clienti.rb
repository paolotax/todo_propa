class AddAncestryToClienti < ActiveRecord::Migration
  def change
    add_column :clienti, :ancestry, :string
    add_column :clienti, :slug, :string

  end
end
