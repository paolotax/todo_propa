class CreateScuole < ActiveRecord::Migration
  def change
    create_table :scuole do |t|
      t.string :nome
      t.string :citta
      t.string :provincia

      t.timestamps
    end
  end
end
