class FatturaStepsController < ApplicationController
  include Wicked::Wizard
  steps :intestazione, :scegli_appunti, :vacanze, :finale 

  def show
    
    # raise params[:fattura_id].inspect
    
    @fattura = current_user.fatture.find(params[:fattura_id])
    
    case step
    when :intestazione
      if @fattura.numero.nil?
        @fattura.numero = @fattura.get_new_id(current_user)
        @fattura.data   = Time.now
      end
    when :scegli_appunti
      @righe = @fattura.cliente.righe.da_fatturare 
    
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
    
    case step
    when :scegli_appunti
      if params[:appunti_ids].present?
        @righe = @fattura.cliente.righe.da_fatturare.where("righe.appunto_id in (?)", params[:appunti_ids])
        @fattura.righe << @righe
      end   
    end
    
    render_wizard @fattura
  end

  private

    def redirect_to_finish_wizard
      redirect_to fatture_url, notice: "Fattura inserita"
    end

end
