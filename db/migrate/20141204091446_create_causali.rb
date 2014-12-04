class CreateCausali < ActiveRecord::Migration
  

  class Fattura < ActiveRecord::Base
  end

  def up
    create_table :causali do |t|
      
      t.string :causale
      
      t.string :magazzino
      t.string :movimento
      t.string :tipo
     
      t.timestamps
    end
    
    Causale.reset_column_information


    Causale.create!(causale: "Fattura", magazzino: "vendita", movimento: "-", tipo: "scarico")

    Causale.create!(causale: "Buono di consegna", magazzino: "vendita", movimento: "-", tipo: "scarico")
    
    Causale.create!(causale: "Nota di accredito", magazzino: "vendita", movimento: "+", tipo: "scarico")
    
    Causale.create!(causale: "Ordine", magazzino: "vendita", movimento: "+", tipo: "carico")

    Causale.create!(causale: "Bolla di carico", magazzino: "vendita", movimento: "+", tipo: "carico")

    Causale.create!(causale: "Resa a fornitore", magazzino: "vendita", movimento: "-", tipo: "carico")

    Causale.create!(causale: "Fattura Acquisti", magazzino: "vendita", movimento: "+", tipo: "carico")

    Fattura.all.each do |v|
      v.causale_id = v.causale_id + 1
      v.save
    end
  end

  def down
    drop_table :causali
  end


end
