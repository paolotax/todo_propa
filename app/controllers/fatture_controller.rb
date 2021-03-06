class FattureController < ApplicationController

  def index
    @fatture = Fattura.per_numero
    @fatture_per_anno = @fatture.group_by { |t| t.data.beginning_of_year }
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @fatture }
    end
  end

  def show
    @fattura = Fattura.includes(:cliente, :user, :righe => [:libro]).find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @fattura }
      
      format.pdf do
        # @fattura = Array(@fattura)
        pdf = FatturaPdf.new(@fattura, view_context)
        send_data pdf.render, filename: "fattura_#{@fattura.id}.pdf",
                              type: "application/pdf",
                              disposition: "inline",
      
      end
      
    end
  end


  def new
    @fattura = Fattura.new
    
    if params[:appunto].present?
      @appunto = Appunto.includes([:cliente, :righe]).find(params[:appunto])
      @fattura.cliente = @appunto.cliente
      @fattura.add_righe_from_appunto(@appunto)      
    end  
    
    @fattura.numero = @fattura.get_new_id(current_user)
    @fattura.data   = Time.now
    @fattura.user   = current_user
    # @appunto_righe = AppuntoRiga.includes([:appunto, :libro]).per_scuola(@scuola).da_fatturare.per_appunto
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fattura }
    end
  end

  def edit
    @fattura = Fattura.find(params[:id])
  end

  # POST /fatture
  # POST /fatture.json
  def create
    @fattura = Fattura.new(params[:fattura])

    respond_to do |format|
      if @fattura.save
        format.html { redirect_to @fattura, notice: 'Fattura creata.' }
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
        format.html { redirect_to @fattura, notice: 'Fattura modificata.' }
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
