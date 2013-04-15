class Api::V1::AdozioniController < Api::V1::BaseController

  doorkeeper_for :all	
  respond_to :json

  def index
		@adozioni = current_resource_owner.mie_adozioni.includes(:libro, :classe)
    respond_with @adozioni
  end

  def update
    @adozione = Adozione.find(params[:id])
    @adozione.update_attributes(params[:adozione])
    respond_with @adozione
	end

end