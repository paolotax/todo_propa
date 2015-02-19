namespace :youpropa do
  

  desc "Crea documenti da fatture"  
  task :create_documenti => :environment do
    
    Appunto.all.each do |a|
      a.update_column :totale_importo, 0.0
    end

    Fattura.order(:id).all.each do |f|

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
      # doc.totale_copie = f.totale_copie
      # doc.totale_importo = f.importo_fattura
      doc.totale_iva = f.totale_iva
      doc.spese = f.spese
      doc.slug = nil

      doc.save
      doc.righe << f.righe

    end

    puts "#{Documento.all.size} documenti creati"

  end

  desc "Imposta lo state della riga"
  task :set_riga_state => :environment do

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

    puts "#{Riga.all.size} righe ricalcolate"
  
  end

end
