class AppuntiController < ApplicationController
  
  can_edit_on_the_spot

  def index
    # @appunti = Appunto.recente.limit(20)
    @search = current_user.appunti.includes(:cliente, :user, :righe => :libro, :visite => :visita_appunti).filtra(params)
   
    @in_corso = @search.in_corso.size
    @da_fare  = @search.da_fare.size
    @in_sospeso = @search.in_sospeso.size    
    @tutti = @search.size
   
    @appunti = @search.recente.limit(30)
    @appunti = @appunti.offset((params[:page].to_i-1)*30) if params[:page].present?

    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)
  end
  
  def get_note
    @appunto = current_user.appunti.find(params[:id])
    render :inline => @appunto.note
  end

  def show
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
    if params[:cliente].present?
      @cliente = Cliente.find(params[:cliente])
    else
      @cliente = nil
    end 
    @appunto = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).build
    @appunto.cliente = @cliente
  end

  def edit
    @appunto = current_user.appunti.includes(:cliente, :user, :righe => [:libro]).find(params[:id])
  end

  def create
    @appunto = current_user.appunti.build(params[:appunto])

    respond_to do |format|
      if @appunto.save
        format.html   { redirect_to appunti_url, notice: 'Appunto creato!' }
        format.mobile { redirect_to  appunti_url }
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
        format.html   { redirect_to appunti_url, notice: 'Appunto modificato.' }
        format.mobile { redirect_to appunti_url }
        format.json
      else
        format.html { render action: "edit" }
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
end
