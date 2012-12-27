module Api
	module V1
		class ClientiController < BaseController
      
      doorkeeper_for :all	
      
		  respond_to :json

		  def index
		    @clienti = current_resource_owner.clienti.order(:titolo)
		    respond_with @clienti
		  end

      def show
        @cliente = current_resource_owner.clienti.find(params[:id])
        @appunti_in_corso = @cliente.appunti.in_corso.order("appunti.id desc")
        respond_with @cliente
      end
	  	  
	  	def create
		    @cliente = current_resource_owner.clienti.create(params[:cliente])
		    respond_with @cliente
		  end
		end
	end
end