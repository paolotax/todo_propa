class VisiteController < ApplicationController
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
      format.js
    end
    # respond_to do |format|
    #   format.html { redirect_to visite_url }
    #   format.js
    #   format.xml  { head :ok }
    # end
  end
end
