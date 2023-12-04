class DocumentiController < ApplicationController


  def index
    
    @tot_documenti = current_user.documenti.filtra(params)
    @documenti = @tot_documenti.includes(:cliente, :righe => [:libro]).per_numero.page(params[:page])    
    @documenti_per_anno = @documenti.group_by { |t| t.data.beginning_of_year }
    
    
    # @righe_da_fatturare = current_user.righe.joins(appunto: :cliente).includes(:libro, appunto: [:cliente]).pagata.da_fatturare.order("clienti.id, appunto_id desc")    
    
    # @righe_da_pagare    = current_user.righe.joins(appunto: :cliente).includes(:libro, :appunto, appunto: [:cliente]).da_pagare.da_fatturare.order("clienti.id, appunto_id desc")

    # if params[:anno]
    #   @righe_da_fatturare = @righe_da_fatturare.dell_anno(params[:anno].to_i)
    #   @righe_da_pagare    = @righe_da_pagare.dell_anno(params[:anno].to_i)
    # end

    respond_to do |format|
      format.html 
      format.js 
      format.xls do
        @documenti = @tot_documenti.order("documenti.causale_id, documenti.data, documenti.numero")
      end
    end
  end


  def show
    @documento = current_user.documenti.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = DocumentoPdf.new(@documento, view_context)
        send_data pdf.render, filename: "#{@documento.slug}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end




  def new

    #session[:return_to] = request.referer

    if params[:cliente].present?
      @cliente = Cliente.find(params[:cliente])
    else
      @cliente = nil
    end 

    @documento = current_user.documenti.build(cliente: @cliente)

  end


  def create
    @documento = current_user.documenti.build(documento_params)

    if @documento.save
      # session[:documento_id] = @documento.id
      redirect_to documento_documento_steps_path(@documento)
    else
      render :new
    end  
  end


  def update
    @documento = current_user.documenti.find(params[:id])

    respond_to do |format|
      if @documento.update_attributes(documento_params)
        format.html { redirect_to @documento, notice: 'Documento was successfully updated.' }
        format.json { head :no_content }
        format.js
      else
        format.html { render action: "edit" }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end


  def destroy
    @documento = current_user.documenti.find(params[:id])
    @documento.destroy

    respond_to do |format|
      format.html { redirect_to documenti_url }
      format.js
    end
  end


  def remove_riga
    @documento = current_user.documenti.find(params[:id])
    riga = @documento.righe.find params[:riga_id]
    @documento.righe = @documento.righe - [riga]
  end


  def create_multiple

    righe = current_user.righe.joins(appunto: :cliente).da_registrare.dell_anno(params[:anno])

    if params[:pagamento] == 'In sospeso'
      righe = righe.where("appunti.stato = 'P'")
    end

    if params[:pagamento] == 'Pagati'
      righe = righe.where("appunti.stato = 'X'")
    end

    if params[:tipo_cliente] == 'Scuole'
      righe = righe.where("clienti.cliente_tipo = 'Scuola Primaria'")
    end

    if params[:tipo_cliente] == 'Altri'
      righe = righe.where("clienti.cliente_tipo != 'Scuola Primaria'")
    end
    
    if params[:data] == 'data ultima modifica'
      righe = righe.order("appunti.updated_at desc, appunti.id desc")
    else
      righe = righe.order("appunti.id desc")
    end

    #raise righe.to_sql.inspect

    if params[:raggruppa]
      righe = righe.group_by(&:cliente)
    else
      righe = righe.group_by(&:appunto)
    end

    #raise righe.inspect   

    crea_documenti righe, params[:causale_id], params[:data]

    redirect_to documenti_url(anno: params[:anno], causale: params[:causale]), notice: "#{ActionController::Base.helpers.pluralize(righe.keys.size, "documento")} generati!"

  end

  def modifica_numero

    @documenti = current_user.documenti.filtra(params).per_numero_asc

    @documenti.each_with_index do |f, i|
      f.update_column(:numero, i + 1)
    end

    redirect_to documenti_url(anno: params[:anno], causale: params[:causale]), notice: "#{ActionController::Base.helpers.pluralize(@documenti.size, "documento")} rinumerati!"

  end



  private


    def documento_params
      params.require(:documento).permit(:causale_id, :cliente_id, :data, :numero, :righe, :appunto_ids, :documento_ids, :pagato)
    end

    def crea_documenti(righe_da_registrare, causale_id, data)

      # last_id = Fattura.where("user_id = ? and data > ? and data < ? and causale_id = ?", current_user.id, data.beginning_of_year, data.end_of_year, causale_id).order('numero desc').limit(1)
      
      # if last_id.empty?
      #   numero_fattura = 1
      # else
      #   numero_fattura = last_id[0][:numero] + 1  
      # end

      righe_da_registrare.reverse_each do |key, righe|
        
        new_righe = righe.sort { |a, b| a.id <=> b.id }

        if key.is_a? Cliente
          cliente_id = key.id
        else
          cliente_id = key.cliente.id
        end

        if data == 'oggi'
          data_documento = Time.now
        elsif data == 'data ultima modifica'
          data_documento = righe.first.appunto.updated_at
        elsif data == 'data creazione'
          data_documento = righe.first.appunto.created_at
        end
          
        if righe.first.appunto.stato == 'X'
          pagato = true
        else
          pagato = false
        end

        fattura = Documento.new( 
            user_id:    current_user.id, 
            causale_id: causale_id, 
            cliente_id: cliente_id, 
            data:       data_documento, 
            numero:     999#,
            #pagata:     pagato
        )

        new_righe.each do |riga|
          r = Riga.find riga.id
          fattura.righe << r
        end

                                         
        fattura.save!

      end 

    end

end
