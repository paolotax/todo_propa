class Api::V1::ClassiController < Api::V1::BaseController

  doorkeeper_for :all	
  respond_to :json

  def index
		@classi = current_resource_owner.classi.includes(:cliente)
    respond_with @classi
  end
  
  def update
    @classe = Classe.find(params[:id])
    @classe.update_attributes(params[:classe])
    respond_with @classe
	end

end
