module Api
	module V1
		class ClientiController < BaseController
      
      doorkeeper_for :all	
      
		  respond_to :json

		  def index
		    @clienti = current_user.clienti.order(:titolo)
		    respond_with @clienti
		  end
	  
		end
	end
end