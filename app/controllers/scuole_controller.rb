class ScuoleController < ApplicationController
  
  
  def index
    
    @search = current_user.scuole.filtra(params)
  
    @scuole = @search.limit(20)
    @scuole = @scuole.offset((params[:page].to_i-1)*20) if params[:page].present?
    
    @provincie = current_user.scuole.select_provincia.filtra(params.except(:provincia).except(:citta)).order(:provincia)
    @citta     = current_user.scuole.select_citta.filtra(params.except(:citta)).order(:citta)
    
    respond_to do |format|
      format.html
      format.json do
        render json: @scuole.map { |s| view_context.scuola_for_mustache(s) }
      end
    end
  end
  
  

  def show
    @scuola = current_user.scuole.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @scuola }
    end
  end

  # GET /scuole/new
  # GET /scuole/new.json
  def new
    @scuola = current_user.scuole.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @scuola }
    end
  end

  # GET /scuole/1/edit
  def edit
    @scuola = Scuola.find(params[:id])
  end

  # POST /scuole
  # POST /scuole.json
  def create
    @scuola = Scuola.new(params[:scuola])

    respond_to do |format|
      if @scuola.save
        format.html { redirect_to @scuola, notice: 'Scuola was successfully created.' }
        format.json { render json: @scuola, status: :created, location: @scuola }
      else
        format.html { render action: "new" }
        format.json { render json: @scuola.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /scuole/1
  # PUT /scuole/1.json
  def update
    @scuola = Scuola.find(params[:id])

    respond_to do |format|
      if @scuola.update_attributes(params[:scuola])
        format.html { redirect_to @scuola, notice: 'Scuola was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @scuola.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scuole/1
  # DELETE /scuole/1.json
  def destroy
    @scuola = Scuola.find(params[:id])
    @scuola.destroy

    respond_to do |format|
      format.html { redirect_to scuole_url }
      format.json { head :ok }
    end
  end
end
