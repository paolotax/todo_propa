class RigheController < ApplicationController
  
  def index
  end
  
  def create
    @riga = Riga.new(params[:riga])

    respond_to do |format|
      if @riga.save
        format.html { redirect_to :back, :notice => 'Appunto riga was successfully created.' }
        format.js
        format.json { render :json => @riga, :status => :created, :location => @riga }
      else
        format.html { render :action => "new" }
        format.json { render :json => @riga.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def update 
    @riga = Riga.find(params[:id])
    respond_to do |format|
      if @riga.update_attributes(params[:riga])
        format.json { render :json => @riga }
      else
        format.json { render :json => @riga.errors, :status => :unprocessable_entity }
      end
    end
  end  

  def destroy
    @riga = Riga.find(params[:id])
    @riga.destroy
    flash[:notice] = 'Riga eliminata.'
    respond_to do |format|
      format.html { redirect_to righe_url }
      format.js
      format.xml  { head :ok }
    end
  end
end
