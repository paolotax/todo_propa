class Api::V1::AppuntiController < Api::V1::BaseController
  
  doorkeeper_for :all
	
  respond_to :json

	def index
    
    if params[:cliente]
      @appunti = current_resource_owner.appunti.where("appunti.cliente_id = ?", params[:cliente]).includes(:cliente).recente
    
    elsif params[:updated_at]
      @appunti = current_resource_owner.appunti.where("appunti.updated_at > ?", params[:updated_at]).includes(:cliente)
    else
		  @appunti = current_resource_owner.appunti.includes(:cliente).recente_modifica.limit(100)
    end

		respond_with @appunti
	end

  def create

    @cliente = current_resource_owner.clienti.find(params[:appunto][:cliente_id])
    @appunto =  @cliente.appunti.build(params[:appunto])
    if @appunto.save
      appunto = current_resource_owner.appunti.includes(:cliente, :righe => :libro).find(@appunto.id)
      #respond_with appunto
      render json: appunto
    end
  end

  def show
    @appunto = current_resource_owner.appunti.includes(:cliente, :righe => :libro).find(params[:id])
    respond_with @appunto
  end

  def update
    @appunto = current_resource_owner.appunti.find(params[:id])

    # raise params[:appunto].inspect
    # @appunto.righe.destroy_all
    
    if @appunto.update_attributes(params[:appunto])
      appunto = current_resource_owner.appunti.includes(:cliente, :righe => :libro).find(@appunto.id)
      #respond_with appunto
      render json: appunto
    else
      respond_with json: { errors: @appunto.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy
    @appunto = current_resource_owner.appunti.find(params[:id])
    @appunto.destroy
    respond_with json: { head: :no_content }
  end

  def print_multiple
    # raise params.inspect
    #current_resource_owner = User.find(1)
    @appunti = current_resource_owner.appunti.includes(:cliente, :user, :righe => [:libro]).find(params[:appunto_ids])
    
    respond_to do |format|
      format.pdf do
        

        #view_context.current_user = current_resource_owner
         
        puts view_context.current_user        
        pdf = AppuntoPdf.new(@appunti, view_context)
        send_data pdf.render, filename: "sovrapacchi_#{Time.now}.pdf",
                              type: "application/pdf",
                              disposition: "inline"
      end
    end   
  end



end