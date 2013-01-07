

module Api
	module V1

		# class MyResponder < ActionController::Responder
		#   def to_format
		#     case
		#     when has_errors?
		#       controller.response.status = :unprocessable_entity
		#     when post?
		#       controller.response.status = :created
		#     end

		#     default_render
		#   rescue ActionView::MissingTemplate => e
		#     api_behavior(e)
		#   end
		# end
		
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


        @cliente = current_resource_owner.clienti.build(params[:cliente])
        

	      if @cliente.save
	        respond_with @cliente#, responder: Api::V1::MyResponder

	      end

        # @cliente.save
        # respond_with @cliente
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