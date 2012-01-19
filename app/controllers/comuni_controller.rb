class ComuniController < ApplicationController
  # GET /comuni
  # GET /comuni.json
  def index
    @comuni = Comune.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @comuni }
    end
  end

  # GET /comuni/1
  # GET /comuni/1.json
  def show
    @comune = Comune.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @comune }
    end
  end

  # GET /comuni/new
  # GET /comuni/new.json
  def new
    @comune = Comune.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @comune }
    end
  end

  # GET /comuni/1/edit
  def edit
    @comune = Comune.find(params[:id])
  end

  # POST /comuni
  # POST /comuni.json
  def create
    @comune = Comune.new(params[:comune])

    respond_to do |format|
      if @comune.save
        format.html { redirect_to @comune, notice: 'Comune was successfully created.' }
        format.json { render json: @comune, status: :created, location: @comune }
      else
        format.html { render action: "new" }
        format.json { render json: @comune.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /comuni/1
  # PUT /comuni/1.json
  def update
    @comune = Comune.find(params[:id])

    respond_to do |format|
      if @comune.update_attributes(params[:comune])
        format.html { redirect_to @comune, notice: 'Comune was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @comune.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comuni/1
  # DELETE /comuni/1.json
  def destroy
    @comune = Comune.find(params[:id])
    @comune.destroy

    respond_to do |format|
      format.html { redirect_to comuni_url }
      format.json { head :ok }
    end
  end
end
