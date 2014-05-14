class MagazzinoController < ApplicationController
  
  def vendite
    
    #@libri_vacanze = (Libro.vacanze.order(:titolo) + Libro.parascolastico.order(:titolo)).flatten

    @libri_vacanze = current_user.righe.not_deleted.scarico.di_questa_propaganda.per_titolo.includes(:libro).map(&:libro).uniq
    
    @da_consegnare = current_user.righe.not_deleted.includes(:appunto => :cliente).da_fare.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    @preparato = current_user.righe.not_deleted.includes(:appunto => :cliente).preparato.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @in_ordine     = current_user.righe_fattura.not_deleted.carico.where("fatture.pagata = false").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    @carichi       = current_user.righe_fattura.not_deleted.carico.where("fatture.pagata = true").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    
    
    @consegnati    = current_user.righe.not_deleted.scarico.consegnata.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @cassa        =  current_user.appunti.not_deleted.
                              completato.where("appunti.totale_importo > 0").
                              where("appunti.created_at > '2013-05-01'").
                              order("Date(appunti.updated_at) desc").
                              group("Date(appunti.updated_at)").
                              sum(:totale_importo)  
  end
  
  
  def cassa
    @incassi = current_user.fatture.where(causale_id: 1).order(:data).select("data, sum(importo_fattura) as incasso").group(:data)
  end  
  
  def incassi
    @completati = current_user.appunti.not_deleted.di_questa_propaganda.completato.order("appunti.updated_at desc")
  end

end