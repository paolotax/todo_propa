# encoding: utf-8

class FatturaStepsController < ApplicationController
  
  include Wicked::Wizard
  steps :intestazione, :scegli_appunti, :vacanze, :finale 

  def show
    
    @fattura = current_user.fatture.find(params[:fattura_id])

    case step
    when :intestazione
      if @fattura.numero.nil?
        @fattura.numero = @fattura.get_new_id(current_user)
        @fattura.data   = Time.now
      end
    when :scegli_appunti
      unless @fattura.ordine?
        @righe = @fattura.cliente.righe.da_fatturare 
        if @righe.empty?
          skip_step
        end
      else
        skip_step
      end
    when :vacanze
      @libri = Libro.vacanze.per_titolo
      @libri.all.each do |l|
        
        if @fattura.ordine?
          prezzo = l.prezzo_copertina
          sconto = 43
        else          
          if !(["Cartolibreria", "Ditta"].include?  @fattura.cliente.cliente_tipo)
            prezzo = l.prezzo_consigliato
            sconto = 0.0
          else
            prezzo = l.prezzo_copertina
            sconto = 20
          end
        end

        @fattura.righe.build(libro: l, prezzo_unitario: prezzo, sconto: sconto)
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
