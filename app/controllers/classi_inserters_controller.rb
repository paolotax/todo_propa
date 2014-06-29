class ClassiInsertersController < ApplicationController

  def new
    @classi_inserter = ClassiInserter.new
  end
  
  def create

    @cliente = current_user.clienti.find(params[:cliente_id])
    @classi_inserter = ClassiInserter.new(params[:classi_inserter])
    if @classi_inserter.valid?
      if @classi_inserter.insert_classi == false
        @classi_inserter.errors[:base] << "la classe inserita esiste gia'" 
      end   
    end
    respond_to do |format|
      format.js
    end
  end

end
