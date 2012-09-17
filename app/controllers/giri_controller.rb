class GiriController < ApplicationController
  
  def index
    @visite         = current_user.visite.settembre.includes(:cliente => :visite).where(baule: false).filtra(params)
    
    @visite_grouped = @visite.order("start desc").group_by {|v| "#{v.to_s}" }
    @nel_baule      = current_user.clienti.nel_baule.filtra(params.except([:controller, :action]))
    
    @scuole_fatte   = current_user.clienti.primarie.con_visite(Visita.settembre).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    
    @scuole_da_fare = current_user.clienti.primarie.senza_visite(Visita.settembre).con_adozioni(Adozione.joins(:classe).scolastico).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    
    @altri_clienti  = current_user.clienti.con_appunti(Appunto.in_corso).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")

    logger.debug { "diff Count: #{@scuole_fatte.count}" }
  end  
  
  
  def show

    @giro = Giro.new(user_id: current_user.id, giorno: Chronic::parse(params[:giorno])) 
    
    @visite  = @giro.visite 
    @clienti = @giro.clienti
    @libri_nel_baule    = @giro.titoli_da_consegnare
    @adozioni_nel_baule = @giro.adozioni_per_titolo     
  end
  
end