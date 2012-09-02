class ClassiInsertersController < ApplicationController

  def new
    @classi_inserter = ClassiInserter.new
  end
  
  def create
    # raise params.inspect
    @classi_inserter = ClassiInserter.new(params[:classi_inserter])
    
    if @classi_inserter.valid?
      @classi_inserter.insert_classi
    end
    
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @cliente = current_user.clienti.find(params[:cliente_id])
      }
      format.json { head :no_content }
    end
  
  end

end
