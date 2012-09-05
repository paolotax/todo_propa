class VisiteController < ApplicationController
  
  
  def index
    @visite = current_user.visite.includes(:cliente => :visite).where(baule: false).order("visite.titolo desc, visite.start desc").filtra(params)
    
    @visite_grouped = @visite.order("start desc").group_by {|v| "#{v.start.strftime("%d-%m")} #{v.titolo}" }
    
    @scuole = current_user.clienti.primarie.includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id").all
    
    logger.debug { "params: #{current_user.clienti.primarie.filtra(params).order("clienti.id").to_sql}" }
    logger.debug { "tutte Count: #{@scuole.count}" }
    
    # elimina le fatte 
    # @visite.each do |v|
    #   @scuole.delete(v.cliente)
    # end
    
    logger.debug { "diff Count: #{@scuole.count}" }
    
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
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @visita.errors, status: :unprocessable_entity }
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
  end
end
