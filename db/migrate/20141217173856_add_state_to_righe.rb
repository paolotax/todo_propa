class AddStateToRighe < ActiveRecord::Migration


  class Documento < ActiveRecord::Base
    has_and_belongs_to_many :righe
    belongs_to :causale
  end

  class Causale < ActiveRecord::Base
    has_many :documenti
  end

  class Riga < ActiveRecord::Base
    has_and_belongs_to_many :documenti
  end


  def up
    add_column :righe, :state, :string
    add_column :righe, :position, :integer
    add_index  :righe, [:id, :position]

    Riga.reset_column_information
    Riga.includes(documenti: :causale).find_each do |riga|
      last_documento = riga.documenti.last
      if last_documento
        if last_documento.causale.causale == "Ordine"
          riga.state = "ordinata"
        elsif last_documento.causale.causale == "Bolla di carico"
          riga.state = "caricata"
        elsif last_documento.causale.causale == "Fattura acquisti"
          riga.state = "fatturata"
        else
          riga.state = "registrata"
        end
      else
        riga.state = "open"
      end
      riga.save
    end
  
  end


  def down
    remove_column :righe, :state
    remove_column :righe, :position, :integer

    remove_index :righe, [:id, :position]
  end
end
