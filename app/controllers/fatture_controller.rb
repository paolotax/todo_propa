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
                              disposition: "inline"
      
      end
    end
  end


  def new
    @fattura = current_user.fatture.build
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @fattura }
    end
  end

  def edit
    @fattura = Fattura.find(params[:id])
  end

  def create

    @fattura = Fattura.new(params[:fattura])

    if @fattura.save
      session[:fattura_id] = @fattura.id
      redirect_to fattura_fattura_steps_path(@fattura)
    else
      render :new
    end  
  end

  def update

    @fattura = Fattura.find(params[:id])

    if @fattura.update_attributes(params[:fattura])
      session[:fattura_id] = @fattura.id
      redirect_to fattura_fattura_steps_path(@fattura)
    else
      render :edit
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
