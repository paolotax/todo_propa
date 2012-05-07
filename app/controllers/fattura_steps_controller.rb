class FatturaStepsController < ApplicationController
  include Wicked::Wizard
  steps :intestazione, :righe, :finale 


  # def create
  #   @fattura = Fattura.create
  #   redirect_to wizard_path(steps.first, :fattura_id => @fattura.id)
  # end
  
  
  
  
  def show
    
    # raise params[:fattura_id].inspect
    
    @fattura = current_user.fatture.find(params[:fattura_id])
    
    case step
      when :intestazione
        @fattura.numero = @fattura.get_new_id(current_user)
        @fattura.data   = Time.now
      when :righe
        @fattura.add_righe_from_cliente(@fattura.cliente)      
    end



    
    
    render_wizard
  end

  def update
    @fattura = current_user.fatture.find(params[:fattura_id])
    @fattura.attributes = params[:fattura]
    render_wizard @fattura
  end

  private

    def redirect_to_finish_wizard
      redirect_to fatture_url, notice: "Fattura inserita"
    end

end
