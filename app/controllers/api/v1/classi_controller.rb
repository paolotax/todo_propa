class Api::V1::ClassiController < Api::V1::BaseController


  doorkeeper_for :all	
  respond_to :json

  #before_filter :get_appunto, except: :index

  def index
    # headers['Last-Modified'] = Time.now.httpdate
  	# current_resource_owner = User.find(1)
		@classi = current_resource_owner.classi
    respond_with @classi
  end

  def show
    # @classe = @cliente.classi.find(params[:id])
    # respond_with @classe
  end
	  
	def create
    # @classe =  @appunto.righe.build(params[:classe].except(:id))
    # if @classe.save
    # 	@appunto.ricalcola
    # 	@appunto.save
    #   respond_with @classe
    # end
  end

  def update
   #  @classe = @appunto.righe.find(params[:id])
   #  if @classe.update_attributes(params[:classe])
   #  	@appunto.ricalcola
   #  	@appunto.save
   #  	respond_with @classe
  	# else
   #  	respond_with json: { errors: @classe.errors.full_messages, status: :unprocessable_entity }
 	 #  end
	end

  def destroy
		# @classe = @appunto.righe.find(params[:id])
		# @classe.destroy
		# @appunto.ricalcola
  #   @appunto.save
		# respond_with json: { head: :no_content }
	end

  private 

    # def get_appunto
    #   @appunto = current_resource_owner.appunti.find(params[:appunto_id])
    # end

end
