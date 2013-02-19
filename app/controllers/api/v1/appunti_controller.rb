class Api::V1::AppuntiController < Api::V1::BaseController
  
  doorkeeper_for :all
	
  respond_to :json

	def index
    # current_resource_owner = User.find(1)
		@appunti = current_resource_owner.appunti.includes(:cliente, :righe => :libro).recente
		respond_with @appunti
	end

  def create

    @cliente = current_resource_owner.clienti.find(params[:appunto][:cliente_id])

    @appunto =  @cliente.appunti.build(params[:appunto].except(:cliente_nome).except(:cliente_id).except(:righe))
    if @appunto.save
      respond_with @appunto
    end
  end

  def show
    @appunto = current_resource_owner.appunti.includes(:cliente, :righe => :libro).find(params[:id])
    respond_with @appunto
  end

  def update

    @appunto = current_resource_owner.appunti.find(params[:id])
    if @appunto.update_attributes(params[:appunto].except(:cliente_nome).except(:righe))
      respond_with @appunto
    else
      respond_with json: { errors: @appunto.errors.full_messages, status: :unprocessable_entity }
    end
  end

  def destroy
    @appunto = current_resource_owner.appunti.find(params[:id])
    @appunto.destroy
    respond_with json: { head: :no_content }
  end


end