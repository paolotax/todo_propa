class AddUuidToAppunti < ActiveRecord::Migration
  
  def up
    add_column :appunti, :uuid, :uuid
    add_column :appunti, :deleted_at, :datetime
    add_column :appunti, :completed_at, :datetime

    add_column :clienti, :uuid, :uuid
    add_column :clienti, :deleted_at, :datetime
    
    add_column :righe, :uuid, :uuid


    say "Inserisci uuids"
    
    Appunto.reset_column_information
    Appunto.find_each do |a|
      a.update_column :uuid, UUIDTools::UUID.random_create.to_s
      if a.completato?
        a.update_column :completed_at, a.updated_at
      end    
    end

    Cliente.reset_column_information
    Cliente.find_each do |a|
      a.update_column :uuid, UUIDTools::UUID.random_create.to_s   
    end

    Riga.reset_column_information
    Riga.find_each do |a|
      a.update_column :uuid, UUIDTools::UUID.random_create.to_s   
    end

  end

  def down
    remove_column :appunti, :uuid, :uuid
    remove_column :appunti, :deleted_at, :datetime
    remove_column :appunti, :completed_at, :datetime

    remove_column :clienti, :uuid, :uuid
    remove_column :clienti, :deleted_at, :datetime
    
    remove_column :righe, :uuid, :uuid
  end
end
