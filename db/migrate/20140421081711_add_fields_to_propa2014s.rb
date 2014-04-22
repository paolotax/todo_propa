class AddFieldsToPropa2014s < ActiveRecord::Migration
  def change
    add_column :propa2014s, :data_vacanze, :date

  end
end
