class AdozioniController < ApplicationController

  def index
    
    @adozioni =  current_user.adozioni.scolastico.includes(:libro, :classe).order("libri.titolo").all.group_by(&:libro).map do |libro, adozioni|
      { 
        materia_id: libro.materia_id, 
        id: libro.id, 
        titolo: libro.titolo, 
        image: libro.image_url(:small_thumb), 
        quantita: adozioni.count(&:classe) 
      }
    end
    
  end

  def destroy_all
    @adozioni = Adozione.destroy(params[:adozioni][:adozione_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @cliente = @adozioni.first.classe.cliente
      }
      format.json { head :no_content }
    end
  end

end
