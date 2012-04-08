class AdozioniController < ApplicationController
  # GET /adozioni
  # GET /adozioni.json
  def index
    @adozioni = Adozione.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @adozioni }
    end
  end

  # GET /adozioni/1
  # GET /adozioni/1.json
  def show
    @adozione = Adozione.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @adozione }
    end
  end

  # GET /adozioni/new
  # GET /adozioni/new.json
  def new
    @adozione = Adozione.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @adozione }
    end
  end

  # GET /adozioni/1/edit
  def edit
    @adozione = Adozione.find(params[:id])
  end

  # POST /adozioni
  # POST /adozioni.json
  def create
    @adozione = Adozione.new(params[:adozione])

    respond_to do |format|
      if @adozione.save
        format.html { redirect_to @adozione, notice: 'Adozione was successfully created.' }
        format.json { render json: @adozione, status: :created, location: @adozione }
      else
        format.html { render action: "new" }
        format.json { render json: @adozione.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /adozioni/1
  # PUT /adozioni/1.json
  def update
    @adozione = Adozione.find(params[:id])

    respond_to do |format|
      if @adozione.update_attributes(params[:adozione])
        format.html { redirect_to @adozione, notice: 'Adozione was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @adozione.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /adozioni/1
  # DELETE /adozioni/1.json
  def destroy
    @adozione = Adozione.find(params[:id])
    @adozione.destroy

    respond_to do |format|
      format.html { redirect_to adozioni_url }
      format.json { head :no_content }
    end
  end
end
