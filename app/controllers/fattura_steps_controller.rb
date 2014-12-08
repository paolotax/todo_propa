class FatturaStepsController < ApplicationController
  
  include Wicked::Wizard
  
  steps :scegli_appunti, :vacanze, :leggi, :dettaglio, :intestazione 
  
  after_filter :generate_appunto, :only => [:update]
  

  def show
    
    @fattura = current_user.fatture.find(params[:fattura_id])

    case step
    
    when :scegli_appunti
      
      unless @fattura.causale.carico?
        @righe = @fattura.cliente.righe.da_fatturare 
      else
        @righe = @fattura.cliente.righe_documenti.completare_carico.di_quest_anno
      end
      skip_step if @righe.empty?

    when :vacanze
      
      settore = params[:settore] || "Vacanze"
      @libri = Libro.send(settore.downcase.underscore).per_titolo
      

      @libri.all.each do |l|
        
        if @fattura.causale.carico?
          prezzo = l.prezzo_copertina
          @sconto = 43
        else          
          if !(["Cartolibreria", "Ditta"].include?  @fattura.cliente.cliente_tipo)
            prezzo = l.prezzo_consigliato
            @sconto = 0.0
          else
            prezzo = l.prezzo_copertina
            @sconto = 20
          end
        end

        @fattura.righe.build(libro: l, prezzo_unitario: prezzo, sconto: @sconto)
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
        appunti = current_user.appunti.includes(:righe).find(params[:appunti_ids])
        appunti.each do |a|
          @fattura.righe << a.righe.select{|r| r.da_registrare? == true}
          if a.stato == 'X'
            @fattura.pagata = true
          else
            @fattura.pagata = false
          end
        end
        jump_to(:dettaglio)
      end

      if params[:fatture_ids].present?
        fatture = current_user.fatture.includes(:righe).find(params[:fatture_ids])        
        fatture.each do |a|
          @fattura.righe << a.righe
        end
        jump_to(:dettaglio)
      end     

    when :leggi, :vacanze 
      jump_to(:dettaglio)
    end
        
    render_wizard(@fattura, notice: 'Documento modificato!') 
  end




  private

    
    def finish_wizard_path
      flash.keep
      fattura_path(@fattura)
    end

    
    def generate_appunto
      unless @fattura.causale.carico?
        case step
        when :dettaglio
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
