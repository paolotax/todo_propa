class FattureController < ApplicationController

  def index
    
    @tot_fatture = current_user.fatture.filtra(params)
    @fatture = @tot_fatture.includes(:cliente, :righe => [:libro]).per_numero.page(params[:page])
    @fatture_per_anno = @fatture.group_by { |t| t.data.beginning_of_year }
    
    @righe_da_fatturare         = current_user.righe.includes(:libro, appunto: [:cliente]).pagata.da_fatturare
    @clienti_righe_da_fatturare = @righe_da_fatturare.group_by(&:cliente)
    
    @righe_da_pagare          = current_user.righe.includes(:libro, :appunto, appunto: [:cliente]).da_pagare.da_fatturare
    @clienti_righe_da_pagare  = @righe_da_pagare.group_by(&:cliente)

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xls do
        @fatture = current_user.fatture.order("fatture.causale_id, fatture.data, fatture.numero")
      end
    end
  end

  def show
    @fattura = current_user.fatture.includes(:cliente, :user, :righe => [:libro]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render rabl: @fattura }

      format.pdf do
        # @fattura = Array(@fattura)
        pdf = FatturaPdf.new(@fattura, view_context)
        send_data pdf.render, filename: "#{@fattura.slug}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end
  end

  def new
    @fattura = current_user.fatture.build
    if params[:causale]
      @fattura.causale_id = params[:causale]
    end
    if params[:cliente_id]
      @fattura.cliente_id = params[:cliente_id]
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fattura }
    end
  end

  def edit
    @fattura = Fattura.find(params[:id])
  end

  def create

    @fattura = Fattura.new(params[:fattura])

    if @fattura.save
      session[:fattura_id] = @fattura.id
      redirect_to fattura_fattura_steps_path(@fattura)
    else
      render :new
    end  
  end

  def update

    @fattura = Fattura.find(params[:id])

    if @fattura.update_attributes(params[:fattura])
      session[:fattura_id] = @fattura.id
      redirect_to fattura_fattura_steps_path(@fattura)
    else
      render :edit
    end
  end

  # DELETE /fatture/1
  # DELETE /fatture/1.json
  def destroy
    @fattura = current_user.fatture.find(params[:id])
    @fattura.destroy

    respond_to do |format|
      format.html { redirect_to fatture_url }
      format.json { head :ok }
      format.js
    end
  end
  
end
