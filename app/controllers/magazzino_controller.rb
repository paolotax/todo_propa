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
    
    righe = current_user.righe.da_fatturare.includes(:libro).joins(:appunto).order("appunti.created_at")

    righe = righe.where("appunti.stato = ?", params[:stato]) if params[:stato].present?
    righe = righe.where("clienti.cliente_tipo = ?", params[:cliente_tipo]) if params[:cliente_tipo].present?
    righe = righe.where("extract(year  from appunti.created_at) = ? ", params[:anno] ) if params[:anno].present?
       
    crea_documenti righe.group_by(&:appunto), 1

    redirect_to fatture_url
  end
  
  def crea_fatture
    righe = current_user.righe.da_fatturare.includes(:libro, :appunto => :cliente).joins(:appunto).order("appunti.created_at")

    righe = righe.where("appunti.stato = ?", params[:stato]) if params[:stato].present?
    righe = righe.where("clienti.cliente_tipo = ?", params[:cliente_tipo]) if params[:cliente_tipo].present?
    righe = righe.where("extract(year  from appunti.created_at) = ? ", params[:anno] ) if params[:anno].present?
       
    crea_documenti righe.group_by(&:cliente), 0
    
    redirect_to fatture_url
  end
  
  private


    def crea_documenti(righe_da_registrare, causale_id)

      for appunto, righe in righe_da_registrare do
        
        if causale_id == 1
          data = appunto.created_at
          cliente_id = appunto.cliente_id
          if appunto.stato == 'X'
            pagato = true
          else
            pagato = false
          end
        else
          data = Time.now
          cliente_id = appunto.id
        end

        last_id = Fattura.where("user_id = ? and data > ? and data < ? and causale_id = ?", current_user.id, data.beginning_of_year, data.end_of_year, causale_id).order('numero desc').limit(1)
        
        if last_id.empty?
          numero_fattura = 1
        else
          numero_fattura = last_id[0][:numero] + 1  
        end

        fattura = Fattura.new( 
            user_id: current_user.id, 
            causale_id: causale_id, 
            cliente_id: cliente_id, 
            data: data, 
            numero: numero_fattura,
            pagata: pagato
        )

        if causale_id == 1
          fattura.add_righe_from_appunto(appunto)
        else
          fattura.add_righe_from_cliente(appunto)
        end
                                         
        fattura.save!

      end 

    end
end


