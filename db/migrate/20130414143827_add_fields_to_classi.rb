class AddFieldsToClassi < ActiveRecord::Migration
  def change

  	add_column :classi, :insegnanti, :string
	  add_column :classi, :note, :text
    add_column :classi, :libro_1, :string
    add_column :classi, :libro_2, :string
    add_column :classi, :libro_3, :string
    add_column :classi, :libro_4, :string

    add_column :adozioni, :kit_1, :string
    add_column :adozioni, :kit_2, :string

  end
end
