class VisiteController < ApplicationController
  
  
  def index
    @visite = current_user.visite.settembre.includes(:cliente => :visite).where(baule: false).filtra(params)
    
    @visite_grouped = @visite.order("date(start) desc").group_by {|v| "#{v.to_s}" }
    @nel_baule      = current_user.clienti.nel_baule.filtra(params.except([:controller, :action]))
    @scuole_fatte   = current_user.clienti.primarie.con_visite(Visita.settembre).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    @scuole_da_fare = current_user.clienti.primarie.senza_visite(Visita.settembre).con_adozioni(Adozione.joins(:classe).scolastico).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    
    @altri_clienti = current_user.clienti.con_appunti(Appunto.in_corso).senza_adozioni(Adozione.joins(:classe).scolastico).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    
    logger.debug { "params: #{current_user.clienti.primarie.filtra(params).order("clienti.id").to_sql}" }
    logger.debug { "tutte Count: #{@scuole_fatte.count}" }
    
    # elimina le fatte 
    # @visite.each do |v|
    #   @scuole.delete(v.cliente)
    # end
    
    logger.debug { "diff Count: #{@scuole_fatte.count}" }
    
    respond_to do |format|
      format.html
      format.json { render :rabl => @visite }
    end
    
  end
  
  
  def create
    @visita = Visita.new(params[:visita])

    respond_to do |format|
      if @visita.save
        format.html { redirect_to :back, :notice => 'Visita pianificata.' }
        format.js
        format.json { render :json => @visita, :status => :created, :location => @visita }
      else
        format.html { render :action => "new" }
        format.json { render :json => @visita.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update
    
    @visita = current_user.visite.find(params[:id])
    respond_to do |format|
      if @visita.update_attributes(params[:visita])
        format.html { redirect_to :back, notice: 'Visita modificata.' }
        format.js
        format.json { render json: @visita }
      else
        format.html { render action: "edit" }
        format.json { render json: @visita.errors, status: :unprocessable_entity }
      end
    end
  end
  
  def destroy
    @visita = Visita.find(params[:id])
    @cliente = @visita.cliente
    @appunti = @cliente.appunti.in_corso
    
    @visita.destroy
    respond_to do |format|
      format.html { redirect_to :back, :notice => 'Visita eliminata.' }
      format.js
    end
  end

  def update_all
  end
  
  
  def destroy_all
    @visite = Visita.destroy(params[:visite][:visita_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
      format.json { head :no_content }
    end
  end

end
