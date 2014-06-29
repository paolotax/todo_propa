class EditoriController < ApplicationController
  # GET /editori
  # GET /editori.json
  def index
    @editori = Editore.order(:nome)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @editori }
    end
  end

  # GET /editori/1
  # GET /editori/1.json
  def show
    @editore = Editore.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @editore }
    end
  end

  # GET /editori/new
  # GET /editori/new.json
  def new
    @editore = Editore.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @editore }
    end
  end

  # GET /editori/1/edit
  def edit
    @editore = Editore.find(params[:id])
  end

  # POST /editori
  # POST /editori.json
  def create
    @editore = Editore.new(params[:editore])

    respond_to do |format|
      if @editore.save
        format.html { redirect_to @editore, notice: 'Editore was successfully created.' }
        format.json { render json: @editore, status: :created, location: @editore }
      else
        format.html { render action: "new" }
        format.json { render json: @editore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /editori/1
  # PUT /editori/1.json
  def update
    @editore = Editore.find(params[:id])

    respond_to do |format|
      if @editore.update_attributes(params[:editore])
        format.html { redirect_to @editore, notice: 'Editore was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @editore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /editori/1
  # DELETE /editori/1.json
  def destroy
    @editore = Editore.find(params[:id])
    @editore.destroy

    respond_to do |format|
      format.html { redirect_to editori_url }
      format.json { head :no_content }
    end
  end
end
