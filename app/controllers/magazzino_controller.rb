class MagazzinoController < ApplicationController
  
  def vendite
    
    #@libri_vacanze = (Libro.vacanze.order(:titolo) + Libro.parascolastico.order(:titolo)).flatten

    @libri_vacanze = current_user.righe.scarico.di_questa_propaganda.per_titolo.includes(:libro).map(&:libro).uniq
    
    @da_consegnare = current_user.righe.includes(:appunto => :cliente).da_fare.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    @preparato = current_user.righe.includes(:appunto => :cliente).preparato.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @in_ordine     = current_user.righe_fattura.carico.where("fatture.pagata = false").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    @carichi       = current_user.righe_fattura.carico.where("fatture.pagata = true").di_quest_anno.per_titolo.includes(:libro).group_by(&:libro)
    
    
    @consegnati    = current_user.righe.scarico.consegnata.di_questa_propaganda.per_titolo.includes(:libro).group_by(&:libro)
    
    @cassa        =  current_user.appunti.
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
    @completati = current_user.appunti.di_questa_propaganda.completato.order("appunti.updated_at desc")
  end
  
  def crea_buoni_di_consegna
    @righe_da_registrare = current_user.righe.
                                        includes(:appunto, :libro, :cliente).
                                        joins(:appunto).
                                        where("appunti.stato = 'X'").
                                        order("appunti.updated_at").
                                        da_fatturare.group_by(&:appunto)

    last_id = Fattura.where("user_id = ? and data >= ? and causale_id = ?", current_user.id, Time.now.beginning_of_year, 1).order('numero desc').limit(1)
    if last_id.empty?
      numero_fattura = 1
    else
      numero_fattura = last_id[0][:numero] + 1  
    end
    
    for k, v in @righe_da_registrare do
      fattura = Fattura.create!( user_id: current_user.id, causale_id: 1, cliente_id: k.cliente_id, data: k.updated_at, numero: numero_fattura)
      for riga in v do
        fattura.righe << riga
      end                                  
      fattura.save!
      numero_fattura += 1
    end                                    
    redirect_to fatture_url
  end
  
  def crea_fatture
    @righe_da_registrare = current_user.righe.
                                        includes(:appunto, :libro, :cliente).
                                        joins(:appunto, :cliente).
                                        where("appunti.stato <> 'X'").
                                        where("clienti.cliente_tipo in ('Cartolibreria', 'Ditta')").
                                        order("appunti.updated_at").
                                        da_fatturare.group_by(&:cliente)

    last_id = Fattura.where("user_id = ? and data >= ? and causale_id = ?", current_user.id, Time.now.beginning_of_year, 1).order('numero desc').limit(1)
    if last_id.empty?
      numero_fattura = 1
    else
      numero_fattura = last_id[0][:numero] + 1  
    end
    
    for k, v in @righe_da_registrare do
      fattura = current_user.fatture.build( causale_id: 2, cliente_id: k.id, data: Time.now, numero: numero_fattura)
      for riga in v do
        fattura.righe << riga
      end                                  
      fattura.save!
      numero_fattura += 1
    end                                    
    redirect_to fatture_url
  end
  
end


