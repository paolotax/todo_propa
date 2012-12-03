class Api::V1::AppuntiController < ApplicationController

	respond_to :json

	def index
		@appunti = current_user.appunti.includes(:cliente, :righe => :libro).recente.limit(100)
		respond_with @appunti
	end

end