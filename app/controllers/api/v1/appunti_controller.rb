class Api::V1::AppuntiController < Api::V1::BaseController
  
  doorkeeper_for :all
	
  respond_to :json

	def index
		@appunti = current_resource_owner.appunti.includes(:cliente, :righe => :libro).recente.limit(100)
		respond_with @appunti
	end

  def create
    @appunto = current_resource_owner.appunti.build(params[:appunto])
    if @appunto.save
      respond_with @appunto
    end
  end

end