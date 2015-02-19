class DocumentoStepsController < ApplicationController
  

  include Wicked::Wizard
  

  steps :scegli_appunti, :vacanze, :leggi, :dettaglio, :intestazione 
  

  after_filter :generate_appunto, :only => [:update]
  

  def show
    
    @documento = current_user.documenti.includes(:causale).find(params[:documento_id])

    case step    
    when :scegli_appunti
      
      if @documento.causale.scarico?
        @righe = @documento.cliente.righe.scarico.non_documentato
      elsif @documento.documento_causale == "Bolla di carico"
        @righe = @documento.cliente.righe_documento.carico.open_carico.uniq
      elsif @documento.documento_causale == "Fattura acquisti"
        @righe = @documento.cliente.righe_documento.carico.open_fattura.uniq
      else  
        @righe = []
      end
      skip_step if @righe.empty?

    when :vacanze
      
      settore = params[:settore] || "Vacanze"
      @libri = Libro.send(settore.downcase.underscore).per_titolo
      
      @libri.all.each do |l|
        
        if @documento.causale.carico?
          prezzo = l.prezzo_copertina
          @sconto = 43
        else          
          if !(["Cartolibreria", "Ditta"].include?  @documento.cliente.cliente_tipo)
            prezzo = l.prezzo_consigliato
            @sconto = 0.0
          else
            prezzo = l.prezzo_copertina
            @sconto = 20
          end
        end

        @documento.righe.build(libro: l, prezzo_unitario: prezzo, sconto: @sconto)
      end   
      
    end

    render_wizard
  end


  def update
    
    @documento = current_user.documenti.find(params[:documento_id])
    @documento.attributes = params[:documento]
    
    #raise params[:documento].inspect


    case step
    when :scegli_appunti
      
      if params[:riga_ids].present?
        if @documento.documento_carico?
          righe = current_user.righe_documento.find(params[:riga_ids]) 
        else
          righe = current_user.righe.find(params[:riga_ids])
        end
        @documento.righe << righe
      end
      jump_to(:dettaglio)
  
    when :leggi, :vacanze 
      jump_to(:dettaglio)
    end
        
    render_wizard(@documento, notice: 'Documento modificato!') 
  end




  private

    
    def finish_wizard_path
      flash.keep
      documento_path(@documento)
    end

    
    def generate_appunto
      unless @documento.documento_carico?
        case step
        
        when :dettaglio
          @righe_nuove = @documento.righe.where("appunto_id is null")
          unless @righe_nuove.empty?
            @new_appunto = @documento.cliente.appunti.build
            @new_appunto.righe << @righe_nuove
            @new_appunto.totale_copie   = @righe_nuove.map(&:quantita).sum
            @new_appunto.totale_importo = @righe_nuove.map(&:importo).sum
            if @documento.pagata?
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
