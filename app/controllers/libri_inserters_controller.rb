class LibriInsertersController < ApplicationController

  def new
    @libri_inserter = LibriInserter.new
  end
  
  def create

    @cliente = current_user.clienti.find(params[:cliente_id])
    
    @libri_inserter = LibriInserter.new(params[:libri_inserter])
    if @libri_inserter.valid?
      if @libri_inserter.insert_libri == false
        @libri_inserter.errors[:base] << "il libro inserito esiste gia'" 
      end   
    end

    @cliente.touch
    
    respond_to do |format|
      format.js
    end
  end

end