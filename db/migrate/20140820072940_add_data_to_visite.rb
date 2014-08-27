class AddDataToVisite < ActiveRecord::Migration
  
  class Visita < ActiveRecord::Base
  end

  def up
    add_column :visite, :data, :date
    
    Visita.reset_column_information
    Visita.all.each do |v|
      v.data = v.start.to_date
      v.save
    end
  
  end

  def down
    remove_column :visite, :data, :date
  end

end
