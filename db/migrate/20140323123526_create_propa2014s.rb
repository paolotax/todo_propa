class CreatePropa2014s < ActiveRecord::Migration
  def change
    create_table :propa2014s do |t|
      t.integer :cliente_id
      t.date :data_visita
      t.date :data_ritiro
      t.date :data_interclasse
      t.date :data_collegio
      t.string :kit_123
      t.integer :nr_123
      t.string :kit_45
      t.integer :nr_45
      t.string :kit_123_ing
      t.integer :nr_45_ing
      t.string :kit_123_rel
      t.integer :nr_123_rel
      t.string :kit_45_rel
      t.integer :nr_45_rel
      t.string :vac_1
      t.string :vac_2
      t.string :vac_3
      t.string :vac_4
      t.string :vac_5
      t.integer :nr_vac_1
      t.integer :nr_vac_2
      t.integer :nr_vac_3
      t.integer :nr_vac_4
      t.integer :nr_vac_5
      t.timestamps
    end

    add_index :propa2014s, :cliente_id
  end
end
