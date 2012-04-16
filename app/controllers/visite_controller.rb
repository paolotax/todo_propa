class VisiteController < ApplicationController
  
  
  def index
    @visite = current_user.visite.includes(:cliente).where(baule: false).filtra(params)
    
    @scuole = current_user.clienti.primarie.filtra(params.except([:controller, :action])).order("clienti.id").all
    
    logger.debug { "params: #{current_user.clienti.primarie.filtra(params).order("clienti.id").to_sql}" }
    logger.debug { "tutte Count: #{@scuole.count}" }
    
    @visite.each do |v|
      @scuole.delete(v.cliente)
    end
    
    logger.debug { "diff Count: #{@scuole.count}" }
    
    # @users = User.filter(:params => params)  
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

  def destroy
    @visita = Visita.find(params[:id])
    @cliente = @visita.cliente
    @visita.destroy
    respond_to do |format|
      format.html { redirect_to :back, :notice => 'Visita eliminata.' }
      format.js
    end
    # respond_to do |format|
    #   format.html { redirect_to visite_url }
    #   format.js
    #   format.xml  { head :ok }
    # end
  end
end
