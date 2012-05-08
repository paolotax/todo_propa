class FatturaStepsController < ApplicationController
  include Wicked::Wizard
  steps :intestazione, :righe, :vacanze, :finale 


  # def create
  #   @fattura = Fattura.create
  #   redirect_to wizard_path(steps.first, :fattura_id => @fattura.id)
  # end
  
  
  
  
  def show
    
    # raise params[:fattura_id].inspect
    
    @fattura = current_user.fatture.find(params[:fattura_id])
    
    case step
      when :intestazione
        if @fattura.numero.nil?
          @fattura.numero = @fattura.get_new_id(current_user)
          @fattura.data   = Time.now
        end
      when :righe
        @fattura.add_righe_from_cliente(@fattura.cliente)    
      
      when :vacanze
        @libri = Libro.vacanze
        @libri.all.each do |l|
          @fattura.righe.build(libro: l, prezzo_unitario: l.prezzo_consigliato)
        end    
            
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
