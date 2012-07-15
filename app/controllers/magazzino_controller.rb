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
  end
  
  def crea_buoni_di_consegna
    @righe_da_registrare = current_user.righe.
                                        includes(:appunto, :libro, :cliente).
                                        joins(:appunto).
                                        where("appunti.stato = 'X'").
                                        order("appunti.updated_at").
                                        da_fatturare.group_by(&:appunto)
    
    
    
    for k, v in @righe_da_registrare do
      fattura = Fattura.create!( causale_id: 1, cliente_id: k.cliente_id, data: k.updated_at)
      fattura.numero = fattura.get_new_id(current_user)
      for riga in v do
        fattura.righe << riga
      end                                  
      fattura.save
    end                                    
    redirect_to fatture_url
  end
end


