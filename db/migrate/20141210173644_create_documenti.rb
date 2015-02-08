class CreateDocumenti < ActiveRecord::Migration
  
  # class Riga < ActiveRecord::Base
  #   has_and_belongs_to_many :documenti
  # end 
  class Documento < ActiveRecord::Base
    has_and_belongs_to_many :righe
  end

  def up
    create_table :documenti do |t|
      
      t.integer :numero
      t.date    :data
      t.text    :note
      t.integer :cliente_id
      t.integer :causale_id
      t.integer :user_id
      
      t.string  :condizioni_pagamento
      t.integer :totale_copie,                                  :default => 0
      
      t.decimal :totale_importo,  :precision => 9, :scale => 2, :default => 0.0
      t.decimal :totale_iva,      :precision => 9, :scale => 2, :default => 0.0
      t.decimal :spese,           :precision => 9, :scale => 2, :default => 0.0
      
      t.string  :state
      t.string  :slug

      t.date    :payed_at
      
      t.timestamps
    end

    add_index :documenti, :cliente_id
    add_index :documenti, :user_id
    add_index :documenti, :causale_id

    create_table :documenti_righe do |t|
      t.integer :documento_id
      t.integer :riga_id
    end

    Documento.reset_column_information

    Fattura.all.each do |f|

      doc = Documento.new
      doc.numero = f.numero
      doc.data   = f.data
      doc.cliente_id = f.cliente_id
      doc.causale_id = f.causale_id
      doc.user_id = f.user_id
      doc.condizioni_pagamento = f.condizioni_pagamento
      if f.pagata == true
        doc.payed_at = f.data
      end
      doc.totale_copie = f.totale_copie
      doc.totale_importo = f.importo_fattura
      doc.totale_iva = f.totale_iva
      doc.spese = f.spese
      doc.slug = f.slug
      doc.righe << f.righe
      
      doc.save

    end

  end

  def down

    drop_table :documenti
    drop_table :documenti_righe
  end

end
