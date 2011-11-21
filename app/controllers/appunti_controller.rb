class AppuntiController < ApplicationController

  def index
    
    @search = Appunto.includes(:scuola).filtra(params)

    @appunti = @search.recente.limit(20)
    @appunti = @appunti.offset((params[:page].to_i-1)*20) if params[:page].present?

    @provincie = Scuola.select_provincia.filtra(params.except(:provincia).except(:citta))
    @citta     = Scuola.select_citta.filtra(params.except(:citta))
    
    respond_to do |format|
      format.html
      format.json do
        render json: @appunti.map { |a| view_context.appunto_for_mustache(a) }
      end
    end
  end

  # GET /appunti/1
  # GET /appunti/1.json
  def show
    @appunto = Appunto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @appunto }
    end
  end

  # GET /appunti/new
  # GET /appunti/new.json
  def new
    @appunto = Appunto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @appunto }
    end
  end

  # GET /appunti/1/edit
  def edit
    @appunto = Appunto.find(params[:id])
  end

  # POST /appunti
  # POST /appunti.json
  def create
    @appunto = Appunto.new(params[:appunto])

    respond_to do |format|
      if @appunto.save
        format.html { redirect_to @appunto, notice: 'Appunto was successfully created.' }
        format.json { render json: @appunto, status: :created, location: @appunto }
      else
        format.html { render action: "new" }
        format.json { render json: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /appunti/1
  # PUT /appunti/1.json
  def update
    @appunto = Appunto.find(params[:id])

    respond_to do |format|
      if @appunto.update_attributes(params[:appunto])
        format.html { redirect_to @appunto, notice: 'Appunto was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @appunto.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /appunti/1
  # DELETE /appunti/1.json
  def destroy
    @appunto = Appunto.find(params[:id])
    @appunto.destroy

    respond_to do |format|
      format.html { redirect_to appunti_url }
      format.json { head :ok }
    end
  end
end
