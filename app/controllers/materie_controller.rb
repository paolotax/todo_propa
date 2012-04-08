class MaterieController < ApplicationController
  # GET /materie
  # GET /materie.json
  def index
    @materie = Materia.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @materie }
    end
  end

  # GET /materie/1
  # GET /materie/1.json
  def show
    @materia = Materia.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @materia }
    end
  end

  # GET /materie/new
  # GET /materie/new.json
  def new
    @materia = Materia.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @materia }
    end
  end

  # GET /materie/1/edit
  def edit
    @materia = Materia.find(params[:id])
  end

  # POST /materie
  # POST /materie.json
  def create
    @materia = Materia.new(params[:materia])

    respond_to do |format|
      if @materia.save
        format.html { redirect_to @materia, notice: 'Materia was successfully created.' }
        format.json { render json: @materia, status: :created, location: @materia }
      else
        format.html { render action: "new" }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /materie/1
  # PUT /materie/1.json
  def update
    @materia = Materia.find(params[:id])

    respond_to do |format|
      if @materia.update_attributes(params[:materia])
        format.html { redirect_to @materia, notice: 'Materia was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @materia.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /materie/1
  # DELETE /materie/1.json
  def destroy
    @materia = Materia.find(params[:id])
    @materia.destroy

    respond_to do |format|
      format.html { redirect_to materie_url }
      format.json { head :no_content }
    end
  end
end
