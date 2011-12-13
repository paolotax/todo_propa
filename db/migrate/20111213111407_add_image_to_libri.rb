class AddImageToLibri < ActiveRecord::Migration
  def change
    add_column :libri, :image, :string
  end
end
