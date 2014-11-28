class FattureController < ApplicationController

  def index
    
    @tot_fatture = current_user.fatture.filtra(params)
    
    @fatture = @tot_fatture.includes(:cliente, :righe => [:libro]).per_numero.page(params[:page])
    
    @fatture_per_anno = @fatture.group_by { |t| t.data.beginning_of_year }
    
    
    @righe_da_fatturare = current_user.righe.joins(appunto: :cliente).includes(:libro, appunto: [:cliente]).pagata.da_fatturare.order("clienti.id, appunto_id desc")    
    
    @righe_da_pagare    = current_user.righe.joins(appunto: :cliente).includes(:libro, :appunto, appunto: [:cliente]).da_pagare.da_fatturare.order("clienti.id, appunto_id desc")


    if params[:anno]
      @righe_da_fatturare = @righe_da_fatturare.dell_anno(params[:anno].to_i)
      @righe_da_pagare    = @righe_da_pagare.dell_anno(params[:anno].to_i)
    end

    respond_to do |format|
      format.html # show.html.erb
      format.js
      format.xls do
        @fatture = @tot_fatture.order("fatture.causale_id, fatture.data, fatture.numero")
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
      respond_to do |format|
        format.html do
          session[:fattura_id] = @fattura.id
          redirect_to fattura_fattura_steps_path(@fattura)
        end
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end      
    end
  end

  def destroy
    @fattura = current_user.fatture.find(params[:id])
    @fattura.destroy

    respond_to do |format|
      format.html { redirect_to fatture_url }
      format.json { head :ok }
      format.js
    end
  end

  def create_multiple

    righe = current_user.righe.joins(appunto: :cliente).da_fatturare.dell_anno(params[:anno])

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

    if params[:raggruppa]
      righe = righe.group_by(&:cliente)
    else
      righe = righe.group_by(&:appunto)
    end

    #raise righe.inspect   

    crea_documenti righe, params[:causale_id], params[:data]

    redirect_to fatture_url(anno: params[:anno], causale: params[:causale]), notice: "#{ActionController::Base.helpers.pluralize(righe.keys.size, "documento")} generati!"

  end

  def modifica_numero

    @fatture = current_user.fatture.filtra(params).per_numero_asc

    @fatture.each_with_index do |f, i|
      f.update_column(:numero, i + 1)
    end

    redirect_to fatture_url(anno: params[:anno], causale: params[:causale]), notice: "#{ActionController::Base.helpers.pluralize(@fatture.size, "documento")} rinumerati!"

  end

  private

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

        fattura = Fattura.new( 
            user_id:    current_user.id, 
            causale_id: causale_id, 
            cliente_id: cliente_id, 
            data:       data_documento, 
            numero:     999,
            pagata:     pagato
        )

        new_righe.each do |riga|
          r = Riga.find riga.id
          fattura.righe << r
        end

                                         
        fattura.save!

      end 

    end

  
end
