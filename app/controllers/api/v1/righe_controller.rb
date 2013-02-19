class Api::V1::RigheController < Api::V1::BaseController


  doorkeeper_for :all	
  respond_to :json

  before_filter :get_appunto, except: :index

  def index
  	# current_resource_owner = User.find(1)
		@righe = current_resource_owner.righe.includes(:appunto, :libro)
    respond_with @righe
  end

  def show
    @riga = @appunto.righe.find(params[:id])
    respond_with @riga
  end
	  
	def create
    @riga =  @appunto.righe.build(params[:riga].except(:id))
    if @riga.save
    	@appunto.ricalcola
    	@appunto.save
      respond_with @riga
    end
  end

  def update
    @riga = @appunto.righe.find(params[:id])
    if @riga.update_attributes(params[:riga])
    	@appunto.ricalcola
    	@appunto.save
    	respond_with @riga
  	else
    	respond_with json: { errors: @riga.errors.full_messages, status: :unprocessable_entity }
 	  end
	end

  def destroy
		@riga = @appunto.righe.find(params[:id])
		@riga.destroy
		@appunto.ricalcola
    @appunto.save
		respond_with json: { head: :no_content }
	end

  private 

    def get_appunto
      @appunto = current_resource_owner.appunti.find(params[:appunto_id])
    end

end
