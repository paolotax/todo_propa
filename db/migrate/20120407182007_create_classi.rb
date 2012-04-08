class CreateClassi < ActiveRecord::Migration
  def change
    create_table :classi do |t|
      
      t.integer  :classe
      t.string   :sezione
      t.integer  :nr_alunni,   :default => 0
      t.integer  :cliente_id
      t.string   :spec_id
      t.string   :sper_id
      
      t.timestamps
    end
    
    add_index :classi, :cliente_id  
    add_index :classi, [:cliente_id, :classe, :sezione], :name => "index_classi_on_scuola_id_and_classe_and_sezione", :unique => true
    
  end
end
