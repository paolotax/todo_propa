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
    @documento = current_user.documenti.build
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
      else
        format.html { render action: "edit" }
        format.json { render json: @documento.errors, status: :unprocessable_entity }
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


  private


    def documento_params
      params.require(:documento).permit(:causale_id, :cliente_id, :data, :numero, :righe, :appunto_ids, :documento_ids)
    end

end
