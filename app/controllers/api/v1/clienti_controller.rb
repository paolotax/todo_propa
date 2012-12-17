module Api
	module V1
		class ClientiController < BaseController
      
      doorkeeper_for :all	
      
		  respond_to :json

		  def index
		    @clienti = current_resource_owner.clienti.order(:titolo)
		    respond_with @clienti
		  end
	  	  
	  	def create
		    @cliente = current_resource_owner.clienti.create(params[:cliente])
		    respond_with @cliente
		  end
		end
	end
end