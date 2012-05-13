class AddIvaToLibri < ActiveRecord::Migration
  def change
    add_column :libri, :iva, :string

  end
end
