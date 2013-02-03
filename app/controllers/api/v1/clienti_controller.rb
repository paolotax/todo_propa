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
        @cliente = current_resource_owner.clienti.includes(:appunti).find(params[:id])
        respond_with @cliente, root: "cliente", :serializer => ClienteAppuntiSerializer
      end
	  	  
	  	def create
        @cliente = current_resource_owner.clienti.build(params[:cliente])
	      if @cliente.save
	        respond_with @cliente#, responder: Api::V1::MyResponder
	      end
		  end

		  def update
		    @cliente = current_resource_owner.clienti.find(params[:id])
	      if @cliente.update_attributes(params[:cliente])
	      	respond_with @cliente
      	else
        	respond_with json: { errors: @cliente.errors.full_messages, status: :unprocessable_entity }
     	  end
    	end
		end
	end
end