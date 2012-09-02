class ClassiController < ApplicationController
 
  def destroy_all
    @classi = Classe.destroy(params[:classi][:classe_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {
        @cliente = @classi.first.cliente
      }
      format.json { head :no_content }
    end
  end
 
end
