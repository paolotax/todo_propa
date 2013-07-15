require "prawn/measurement_extensions"

class AppuntiController < ApplicationController
  
  #before_filter :authenticate_user!

  can_edit_on_the_spot

  def index
    session[:return_to] = request.path

    @search = current_user.appunti.includes(:cliente, :user, :righe => :libro, :visite => :visita_appunti).filtra(params).ordina(params)
    if params[:tag]
      @search = @search.tagged_with(params[:tag])
    end

    @appunti = @search.page(params[:page])
    
    @stat_appunti = current_user.appunti.filtra(params.except(:status))
    @in_corso     = @stat_appunti.in_corso.size
    @da_fare      = @stat_appunti.da_fare.size
    @in_sospeso   = @stat_appunti.in_sospeso.size
    @preparati    = @stat_appunti.preparato.size    
    @tutti        = @stat_appunti.size

    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)

    location = params[:comune] || "bologna"
    location = location.split.join("_").downcase
    @wunder = Wunderground.new location

  end
  
  def get_note
    @appunto = current_user.appunti.find(params[:id])
    render :inline => @appunto.note
  end

  def show
    session[:return_to] = request.path    
    @appunto = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).find(params[:id])
    
    respond_to do |format|
      format.html  # show.html.erb
      format.js
      format.json  { render :rabl => @appunto }

      format.pdf do
        @appunti = Array(@appunto)
        pdf = AppuntoPdf.new(@appunti, view_context)
        send_data pdf.render, filename: "appunto_#{@appunto.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      
      end
    end
    
    # respond_to do |format|
    #   format.html # show.html.erb
    #   format.json { render rabl: @appunto }
    # end
  end

  def new
    session[:return_to] = request.referer
    if params[:cliente].present?
      @cliente = Cliente.find(params[:cliente])
    else
      @cliente = nil
    end 
    @appunto = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).build(destinatario: params[:destinatario], telefono: params[:telefono])
    @appunto.cliente = @cliente
  end

  def edit
    session[:return_to] = request.referer
    @appunto = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).find(params[:id])
  end

  def create
    @appunto = current_user.appunti.build(params[:appunto])
    respond_to do |format|
      if @appunto.save
        format.html   { redirect_to session[:return_to], notice: 'Appunto creato!' }
        format.json
      else
        format.html { render action: "new" }
        format.json { render rabl: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @appunto = current_user.appunti.find(params[:id])
    respond_to do |format|
      if @appunto.update_attributes(params[:appunto])
        format.html   { redirect_to session[:return_to], notice: 'Appunto modificato.' }
        format.mobile { redirect_to appunti_url }
        format.js
        format.json
      else
        format.html { render action: "edit" }
        format.js
        format.json { render rabl: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @appunto = current_user.appunti.find(params[:id])
    @appunto.destroy
    respond_to do |format|
      format.html { redirect_to appunti_url }
      format.json { head :ok }
      format.js
    end
  end
  
  def print_multiple
    raise params.inspect
    @appunti = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).find(params[:appunto_ids])
    
    respond_to do |format|
      format.pdf do
        
        case params[:tipo_etichetta]
          when "2x4 con bordo"
            options = {
              top_margin: 4.mm,
              bottom_margin: 4.mm,
              page_layout: :portrait,
              start_from: params[:etichetta_da],
              labels_per_page: 8,
              columns: 2,
              print_logo: "small",
              print_pieghi: true,
              destinatario_top: 3.4.cm,
              destinatario_left: 2.5.cm
            }
          when "2x4 senza bordo"
            options = {
              page_layout: :portrait,
              start_from: params[:etichetta_da],
              labels_per_page: 8,
              columns: 2,
              print_logo: "small",
              print_pieghi: true,
              destinatario_top: 3.4.cm,
              destinatario_left: 2.5.cm
            }
            
          when "2x6"
            options = {
              top_margin: 4.mm,
              bottom_margin: 4.mm,
              page_layout: :portrait,
              start_from: params[:etichetta_da],
              labels_per_page: 12,
              columns: 2,
              print_logo: "small",
              print_pieghi: true,
              destinatario_top: 2.cm,
              destinatario_left: 2.cm
            }
          when "3x8"
            options = {
              top_margin: 4.mm,
              bottom_margin: 4.mm,
              page_layout: :portrait,
              start_from: params[:etichetta_da],
              labels_per_page: 24,
              columns: 3
            }
          when "Dymo 99012"
            options = {
              page_size:  [36.mm, 89.mm],
              labels_per_page: 1,
              columns: 1
            }
        end  
        
                
        pdf = EtichettaPdf.new(@appunti, view_context, options)
        send_data pdf.render, filename: "sovrapacchi_#{Time.now}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end   
  end
end
