class ClientiController < ApplicationController
  
  can_edit_on_the_spot
  
  def index

    @search = current_user.clienti.filtra(params)
    @clienti = @search.limit(20)

    @clienti = @clienti.offset((params[:page].to_i-1)*20) if params[:page].present?

    @provincie = current_user.clienti.select_provincia.filtra(params.except(:provincia).except(:citta)).order(:provincia)
    @citta     = current_user.clienti.select_citta.filtra(params.except(:citta)).order(:citta)
  end

  def show
    @cliente = current_user.clienti.includes(:indirizzi).find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cliente }
    end
  end

  def new
    @cliente   = current_user.clienti.build
    @indirizzo  = @cliente.indirizzo
    # @spedizione = @cliente.indirizzo_spedizione
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cliente }
    end
  end

  def edit
    @cliente = current_user.clienti.find(params[:id])
  end

  def create
    @cliente = current_user.clienti.build(params[:cliente])

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to @cliente, notice: 'Cliente creato.' }
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
        format.html { redirect_to @cliente, notice: 'Cliente modificato.' }
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
