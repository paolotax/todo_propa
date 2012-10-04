class ClientiController < ApplicationController
  
  can_edit_on_the_spot
  
  def index
    session[:return_to] = request.path
    @search = current_user.clienti.per_localita.filtra(params)
    @clienti = @search.includes(:visite).page(params[:page])
    
    # stats
    @stat_clienti    = current_user.clienti.per_localita.filtra(params.except(:status))
    @search_appunti  = current_user.appunti.filtra(params.except(:status))
    @in_corso   = @stat_clienti.con_appunti(@search_appunti.in_corso).size
    @da_fare    = @stat_clienti.con_appunti(@search_appunti.da_fare).size
    @in_sospeso = @stat_clienti.con_appunti(@search_appunti.in_sospeso).size    
    @tutti      = @stat_clienti.size 
    
    #filters
    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:comune)).order(:comune)
  end

  def show
    session[:return_to] = request.path
    
    @cliente = current_user.clienti.includes(:indirizzi, :appunti, :fatture, :righe, :visite).find(params[:id])
    
    @adozioni_per_scuola = @cliente.adozioni.joins(:classe).scolastico.order("classi.classe, classi.sezione").group_by(&:libro)
    
    @classi_inserter = ClassiInserter.new
    
    if request.path != cliente_path(@cliente)
      redirect_to @cliente, status: :moved_permanently
    end
  end

  def new
    session[:return_to] = request.referer
    @cliente   = current_user.clienti.build
    @indirizzo  = @cliente.indirizzo
    # @spedizione = @cliente.indirizzo_spedizione
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cliente }
    end
  end

  def edit
    session[:return_to] = request.referer
    @cliente = current_user.clienti.find(params[:id])
  end

  def create
    @cliente = current_user.clienti.build(params[:cliente])

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to session[:return_to], notice: 'Cliente creato.' }
        format.json { render json: @cliente, status: :created, location: @cliente }
      else
        format.html { render action: "new" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @cliente = Cliente.find(params[:id])
    
    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        format.html { redirect_to session[:return_to], notice: 'Cliente modificato.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cliente = Cliente.find(params[:id])
    @cliente.destroy

    respond_to do |format|
      format.html { redirect_to clienti_url }
      format.json { head :ok }
    end
  end
end
