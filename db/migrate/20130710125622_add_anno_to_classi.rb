class AddAnnoToClassi < ActiveRecord::Migration
  def up
    add_column :classi, :anno, :string

    say "Inserisci anno scolastico 2012 in classi"
    
    Classe.reset_column_information

    Classe.all.each do |c|
      c.update_attribute :anno, "2012"      
    end
  end

  def down
    remove_column :classi, :anno, :string
  end

end
