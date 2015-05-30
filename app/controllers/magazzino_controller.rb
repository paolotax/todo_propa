class MagazzinoController < ApplicationController
  
  
  def vendite_da_consegnare

    set_filtri anno: Time.now.year.to_s, status: 'da consegnare' 

    @vendite = current_user.righe.scarico.filtra(@filtri)
    
    @comuni  = @vendite.map{|v| v.appunto.cliente.comune}.uniq
    @clienti = @vendite.map{|v| v.appunto.cliente}.uniq.sort_by{|c| [c.provincia, c.comune, c.titolo]}


    if params[:comune].present?
      @vendite = @vendite.select{|r| r.appunto.cliente.comune == params[:comune]}

      @clienti = @clienti.select{|c| c.comune == params[:comune]}

    end

    if params[:cliente].present?
      @vendite = @vendite.select{|r| r.appunto.cliente.titolo == params[:cliente]}
    end

    @appunti = @vendite.group_by(&:appunto).keys.sort_by{|a| [a.cliente.provincia, a.cliente.titolo]}


  end


  def vendite_nuove 

    set_filtri anno: Time.now.year.to_s

    @giacenza = GiacenzaCounter.new(user: current_user, params: @filtri).per_settore


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


  private


    def set_filtri(defaults)

      @filtri = ActiveSupport::HashWithIndifferentAccess.new defaults
      
      @filtri = @filtri.merge!(params)
      
      @anno   = @filtri[:anno]
      @status = @filtri[:status]

    end


end