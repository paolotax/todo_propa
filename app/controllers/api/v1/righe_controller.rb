module Api
	module V1

		class RigheController < BaseController
      

      doorkeeper_for :all	
		  respond_to :json

      before_filter :get_appunto

		  def index
		    @righe = @appunto.righe.all
		    respond_with @righe
		  end

      def show
        @riga = @appunto.righe.find(params[:id])
        respond_with @riga
      end
	  	  
	  	def create
        raise params.inspect
        @riga =  @appunto.righe.build(params[:cliente])
	      if @riga.save
	        respond_with @riga
	      end
		  end

		  def update
        raise params.inspect
		    @riga = @appunto.righe.find(params[:id])
	      if @riga.update_attributes(params[:riga])
	      	respond_with @riga
      	else
        	respond_with json: { errors: @riga.errors.full_messages, status: :unprocessable_entity }
     	  end
    	end

      private 

        def get_appunto
          @appunto = current_resource_owner.appunti.find(params[:appunto_id])
        end

		end
	end
end