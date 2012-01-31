class CreateVisite < ActiveRecord::Migration
  def change
    create_table :visite do |t|

      t.integer :cliente_id
      t.string  :titolo
      t.datetime :start
      t.datetime :end
      t.boolean :all_day
      t.boolean :baule
      t.string  :scopo
      t.integer :giro_id
      t.timestamps
    end
    
    add_index :visite, :cliente_id
  end
end
