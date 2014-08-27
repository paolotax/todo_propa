require 'chronic'

class GiriController < ApplicationController
  
  def index
    
    @visite         = current_user.visite.settembre.includes(:cliente => :visite).where(baule: false).filtra(params)
    
    @visite_grouped = @visite.order("start desc").group_by(&:data)
    
    @nel_baule      = current_user.clienti.nel_baule.filtra(params.except([:controller, :action]))
    
    @scuole_fatte   = current_user.clienti.primarie
                                  .con_visite(current_user.visite.settembre)
                                  .includes(:appunti, :visite)
                                  .filtra(params.except([:controller, :action]))
                                  .order("clienti.id")
    
    @scuole_da_fare = current_user.clienti.primarie
                                  .senza_visite(current_user.visite.settembre)
                                  .con_adozioni(current_user.adozioni.scolastico)
                                  .includes(:appunti, :visite)
                                  .filtra(params.except([:controller, :action]))
                                  .order("clienti.id")
    
    # rimettere se solo scuole con adozioni
    #.con_adozioni(current_user.adozioni.scolastico)
    @scuole_da_fare_senza = current_user.clienti.primarie
                                  .senza_visite(current_user.visite.settembre)
                                  .senza_adozioni(current_user.adozioni.scolastico)
                                  .includes(:appunti, :visite)
                                  .filtra(params.except([:controller, :action]))
                                  .order("clienti.id")                              

    @clienti_da_fare = current_user.clienti
                                  .con_appunti(current_user.appunti.da_fare)
                                  .includes(:appunti, :visite)
                                  .filtra(params.except([:controller, :action]))
                                  .order("clienti.id")

    @clienti_in_sospeso = current_user.clienti
                                  .con_appunti(current_user.appunti.in_sospeso)
                                  .includes(:appunti, :visite)
                                  .filtra(params.except([:controller, :action]))
                                  .order("clienti.id")


  end  
  

  def show
    @giro = Giro.new(user: current_user, giorno: Date.parse(params[:giorno])) 
  end


  def print_multiple

    @giro = Giro.new(user: current_user, giorno: Date.parse(params[:giorno]))
    
    respond_to do |format|
      format.pdf do
        pdf = GiroPdf.new(@giro.clienti, view_context)
        send_data pdf.render, filename: "giri_#{Time.now}.pdf",
                              type: "application/pdf",
                              disposition: "inline"

      end
    end   
  end
  

  
end