class MagazzinoController < ApplicationController
  
  def vendite_nuove

    @vendite = current_user.righe.scarico.includes(:libro).group_by(&:libro).map do |l, righe|
      { 
        libro: l, 
        copie: righe.sum(&:quantita),
        importo: righe.sum(&:importo)
      }
    end

  end


  def vendite
    
    #@libri_vacanze = (Libro.vacanze.order(:titolo) + Libro.parascolastico.order(:titolo)).flatten

    @libri_vacanze = current_user.righe.not_deleted.scarico.di_questa_propaganda.per_titolo.includes(:libro).map(&:libro).uniq
    
    @da_consegnare = current_user.righe.not_deleted.includes(:appunto => :cliente).da_fare.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @preparato = current_user.righe.not_deleted.includes(:appunto => :cliente).preparato.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    
    @in_ordine     = current_user.righe_fattura.carico.where("fatture.pagata = false").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    
    @carichi       = current_user.righe_fattura.carico.where("fatture.pagata = true").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    
    
    @consegnati    = current_user.righe.not_deleted.scarico.consegnata.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @cassa  = current_user.fatture.where(causale_id: 2).where("fatture.data >= '2014-01-01'").order("fatture.data desc").select("data, sum(importo_fattura) as totale_importo").group(:data)
    # @cassa        =  current_user.appunti.not_deleted.joins(righe: :fattura).
    #                           completato.where("appunti.totale_importo > 0").
    #                           where("appunti.created_at >= '2014-01-01'").
    #                           order("Date(fatture.data) desc").
    #                           group("Date(fatture.data)").
    #                           sum(:totale_importo)  
  end
  
  
  def cassa
    @incassi = current_user.fatture.where(causale_id: 2).order(:data).select("data, sum(importo_fattura) as incasso").group(:data)
  end  


  def incassi
    @completati = current_user.appunti.not_deleted.di_questa_propaganda.completato.order("appunti.updated_at desc")
  end

end