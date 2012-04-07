class AddSlugToLibri < ActiveRecord::Migration
  def change
    add_column :libri, :slug, :string
    add_index :libri,  :slug
  end
end
