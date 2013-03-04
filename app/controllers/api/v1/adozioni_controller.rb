class Api::V1::AdozioniController < Api::V1::BaseController


  doorkeeper_for :all	
  respond_to :json

  #before_filter :get_appunto, except: :index

  def index
    # headers['Last-Modified'] = Time.now.httpdate
  	# current_resource_owner = User.find(1)
		@adozioni = current_resource_owner.mie_adozioni.includes(:libro, :classe)
    respond_with @adozioni
  end

  def show
    # @adozione = @cliente.adozioni.find(params[:id])
    # respond_with @adozione
  end
	  
	def create
    # @adozione =  @appunto.righe.build(params[:adozione].except(:id))
    # if @adozione.save
    # 	@appunto.ricalcola
    # 	@appunto.save
    #   respond_with @adozione
    # end
  end

  def update
   #  @adozione = @appunto.righe.find(params[:id])
   #  if @adozione.update_attributes(params[:adozione])
   #  	@appunto.ricalcola
   #  	@appunto.save
   #  	respond_with @adozione
  	# else
   #  	respond_with json: { errors: @adozione.errors.full_messages, status: :unprocessable_entity }
 	 #  end
	end

  def destroy
		# @adozione = @appunto.righe.find(params[:id])
		# @adozione.destroy
		# @appunto.ricalcola
  #   @appunto.save
		# respond_with json: { head: :no_content }
	end

  private 

    # def get_appunto
    #   @appunto = current_resource_owner.appunti.find(params[:appunto_id])
    # end

end