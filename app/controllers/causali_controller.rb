class CausaliController < ApplicationController
  # GET /causali
  # GET /causali.json
  def index
    @causali = Causale.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @causali }
    end
  end

  # GET /causali/1
  # GET /causali/1.json
  def show
    @causale = Causale.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @causale }
    end
  end

  # GET /causali/new
  # GET /causali/new.json
  def new
    @causale = Causale.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @causale }
    end
  end

  # GET /causali/1/edit
  def edit
    @causale = Causale.find(params[:id])
  end

  # POST /causali
  # POST /causali.json
  def create
    @causale = Causale.new(causale_params)

    respond_to do |format|
      if @causale.save
        format.html { redirect_to @causale, notice: 'Causale was successfully created.' }
        format.json { render json: @causale, status: :created, location: @causale }
      else
        format.html { render action: "new" }
        format.json { render json: @causale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /causali/1
  # PATCH/PUT /causali/1.json
  def update
    @causale = Causale.find(params[:id])

    respond_to do |format|
      if @causale.update_attributes(causale_params)
        format.html { redirect_to @causale, notice: 'Causale was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @causale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /causali/1
  # DELETE /causali/1.json
  def destroy
    @causale = Causale.find(params[:id])
    @causale.destroy

    respond_to do |format|
      format.html { redirect_to causali_url }
      format.json { head :no_content }
    end
  end

  private

    # Use this method to whitelist the permissible parameters. Example:
    # params.require(:person).permit(:name, :age)
    # Also, you can specialize this method with per-user checking of permissible attributes.
    def causale_params
      params.require(:causale).permit(:causale, :magazzino, :movimento)
    end
end
