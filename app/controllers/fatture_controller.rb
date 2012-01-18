class FattureController < ApplicationController
  # GET /fatture
  # GET /fatture.json
  def index
    @fatture = Fattura.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fatture }
    end
  end

  # GET /fatture/1
  # GET /fatture/1.json
  def show
    @fattura = Fattura.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fattura }
    end
  end

  # GET /fatture/new
  # GET /fatture/new.json
  def new
    @fattura = Fattura.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fattura }
    end
  end

  # GET /fatture/1/edit
  def edit
    @fattura = Fattura.find(params[:id])
  end

  # POST /fatture
  # POST /fatture.json
  def create
    @fattura = Fattura.new(params[:fattura])

    respond_to do |format|
      if @fattura.save
        format.html { redirect_to @fattura, notice: 'Fattura was successfully created.' }
        format.json { render json: @fattura, status: :created, location: @fattura }
      else
        format.html { render action: "new" }
        format.json { render json: @fattura.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /fatture/1
  # PUT /fatture/1.json
  def update
    @fattura = Fattura.find(params[:id])

    respond_to do |format|
      if @fattura.update_attributes(params[:fattura])
        format.html { redirect_to @fattura, notice: 'Fattura was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @fattura.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fatture/1
  # DELETE /fatture/1.json
  def destroy
    @fattura = Fattura.find(params[:id])
    @fattura.destroy

    respond_to do |format|
      format.html { redirect_to fatture_url }
      format.json { head :ok }
    end
  end
end
