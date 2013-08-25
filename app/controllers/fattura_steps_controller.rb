# encoding: utf-8

class FatturaStepsController < ApplicationController
  
  include Wicked::Wizard
  
  steps :intestazione, :scegli_appunti, :vacanze, :finale 
  
  after_filter :generate_appunto, :only => [:update]
  
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

    def generate_appunto
      unless @fattura.ordine?
        case step
        when :vacanze, :finale
          @righe_nuove = @fattura.righe.where("appunto_id is null")
          unless @righe_nuove.empty?
            @new_appunto = @fattura.cliente.appunti.build
            @new_appunto.righe << @righe_nuove
            @new_appunto.totale_copie   = @righe_nuove.map(&:quantita).sum
            @new_appunto.totale_importo = @righe_nuove.map(&:importo).sum
            if @fattura.pagata?
              @new_appunto.status = "completato"
            else
              @new_appunto.status = "in_sospeso"
            end
            @new_appunto.save
          end
        end
      end
    end

end
