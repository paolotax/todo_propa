class MagazzinoController < ApplicationController
  
  def vendite
    
    @libri_vacanze = Libro.vacanze

    @da_consegnare = current_user.righe.includes(:appunto => :cliente).scarico.da_consegnare.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @in_ordine     = current_user.righe_fattura.carico.where("fatture.pagata = false").di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    @carichi       = current_user.righe_fattura.carico.where("fatture.pagata = true").di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    
    @consegnati    = current_user.righe.scarico.consegnata.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @cassa        =  current_user.appunti.
                              completo.where("appunti.totale_importo > 0").
                              where("appunti.created_at > '2012-05-01'").
                              order("Date(appunti.updated_at) desc").
                              group("Date(appunti.updated_at)").
                              sum(:totale_importo)  
    
    
    
    
    
    # @situazione = []
    # 
    # @libri_vacanze.all.each do |l|
    #   @situazione << {
    #         libro:                l,
    #         da_consegnare:        l.righe.scarico.da_consegnare.di_questa_propaganda.per_titolo,
    #         totale_da_consegnare: l.righe.scarico.da_consegnare.di_questa_propaganda.sum(&:quantita),
    #         consegnati:           l.righe.di_questa_propaganda.consegnata.per_titolo,
    #         totale_consegnati:    l.righe.di_questa_propaganda.consegnata.per_titolo.sum(&:quantita),
    #         in_ordine:            l.righe.carico.di_questa_propaganda.per_titolo,
    #         totale_in_ordine:     l.righe.carico.di_questa_propaganda.per_titolo.sum(&:quantita),
    #   }
    # 
    # end  
  end
  
end
