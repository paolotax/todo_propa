class CreateComuni < ActiveRecord::Migration
  def change
    create_table :comuni do |t|
      t.string :istat
      t.string :comune
      t.string :provincia
      t.string :regione
      t.string :prefisso
      t.string :cap
      t.string :codfisco
      t.integer :abitanti
      t.string :link

      t.timestamps
    end
  end
end
