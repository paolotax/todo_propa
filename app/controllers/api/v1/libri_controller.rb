module Api
	module V1

		class LibriController < BaseController
      
		  respond_to :json

		  def index
		    @libri = Libro.where("libri.settore <> 'Concorrenza'").order(:titolo)
		    respond_with @libri
		  end

      def show
        @libro = Libro.find(params[:id])
        respond_with @libro
      end
	  	  
	  	def create
        @libro = Libro.create(params[:libro])
	      if @libro.save
	        respond_with @libro
	      end
		  end

		  def update
		    @libro = Libro.find(params[:id])
	      if @libro.update_attributes(params[:libro])
	      	respond_with @libro
      	else
        	respond_with json: { errors: @libro.errors.full_messages, status: :unprocessable_entity }
     	  end
    	end
		end
	end
end