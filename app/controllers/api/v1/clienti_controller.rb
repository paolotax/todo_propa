module Api
	module V1
		class ClientiController < ApplicationController
  
		  respond_to :json

		  def index
		    @clienti = current_user.clienti.order(:titolo)
		    respond_with @clienti
		  end
		
		end
	end
end