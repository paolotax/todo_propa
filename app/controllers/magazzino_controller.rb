class MagazzinoController < ApplicationController
  
  
  def vendite_da_consegnare

    @anno   = params[:anno] || Time.now.year.to_s
    @status = params[:status] || 'da consegnare'

    @vendite = current_user.righe.scarico.dell_anno(@anno)


    if @status == 'preparate' 
      @vendite = @vendite.preparate
    elsif @status == 'da pagare'
      @vendite = @vendite.da_pagare
    elsif @status == 'da registrare'
      @vendite = @vendite.da_registrare
    else
      @status = 'da consegnare'
      @vendite = @vendite.da_consegnare
    end

    @appunti = @vendite.group_by(&:appunto).keys

  end


  def vendite_nuove

    anno = params[:anno] || Time.now.year

    @giacenza = GiacenzaCounter.new(user: current_user, anno: anno, params: nil).per_settore


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