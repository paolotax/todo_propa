namespace :youpropa do
  
  desc "ricalcola counters"  
  task :ricalcola_counters => :environment do
    Rails.application.eager_load!

    ActiveRecord::Base.descendants.each do |many_class|
      many_class.reflections.each do |name, reflection|
        if reflection.options[:counter_cache]
          one_class = reflection.class_name.constantize
          one_table, many_table = [one_class, many_class].map(&:table_name)
          ids = one_class
            .joins(many_table.to_sym)
            .group("#{one_table}.id")
            .having("#{one_table}.#{many_table}_count != COUNT(#{many_table}.id)")
            .pluck("#{one_table}.id")
          ids.each do |id|
            one_class.reset_counters id, many_table
            puts "reset #{one_class} #{id}"
          end

        end
      end
    end

    puts "---Fine ricalcola_counters---"
  end


  


  desc "Reimposta id_documento e new states"  
  task :reimposta_id_documento => :environment do
    
    # # Riga.counter_culture_fix_counts
    # Appunto.includes(:righe).all.each do |a|
    #   a.update_attributes righe_count: a.righe.size
    # end

    Riga.all.each do |r|
      r.update_attributes documento_id: r.documenti.order(:causale_id).last.try(:id)
      r.check_scarico_state if r.scarico?
    end
  end


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

      last_documento = riga.documenti.order(:causale_id).last
      
      
      if last_documento

        riga.pagata_il = last_documento.payed_at

        if last_documento.ordine?
          riga.state = "ordinata"
        elsif last_documento.bolla_di_carico?
          riga.state = "caricata"
          riga.consegnata_il = last_documento.data
        elsif last_documento.fattura_acquisti?
          riga.state = "fatturata"
          riga.consegnata_il = last_documento.data
        elsif last_documento.buono_di_consegna?
          riga.state = "corrispettivi"
          riga.consegnata_il = last_documento.data
        else
          riga.state = "registrata"
          riga.consegnata_il = last_documento.data       
        end
        
      else

        riga.state = "open"
        if riga.appunto
          if riga.appunto.stato == 'P'
            riga.consegnata_il = riga.appunto.created_at.to_date
            riga.state = 'consegnata'
          elsif riga.appunto.stato = 'X'
            riga.state = 'consegnata'
            riga.consegnata_il = riga.appunto.created_at.to_date
            riga.pagata_il = riga.appunto.created_at.to_date
          end
        end

      end
      riga.save
    end

    puts "#{Riga.all.size} righe ricalcolate"
  
  end

end
