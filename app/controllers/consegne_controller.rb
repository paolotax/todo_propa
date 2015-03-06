class ConsegneController < ApplicationController
  

  def create
    load_consegna
    
    if @consegna.valid?
      @consegna.esegui
    end
    
    redirect_to :back
  end


  private

    def load_consegna
      @consegna = Consegna.new(
        data:     params[:consegna][:data],
        riga_ids: params[:riga_ids],
        user:     current_user,
        azione:   params[:consegna][:azione]
      )
    end


end
