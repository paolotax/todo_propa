class CreateEditori < ActiveRecord::Migration
  def change
    create_table :editori do |t|
      t.string :nome
      t.string :gruppo
      t.string :codice

      t.timestamps
    end
  end
end
