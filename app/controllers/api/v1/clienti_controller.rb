class Api::V1::ClientiController < Api::V1::BaseController
      
  doorkeeper_for :all	
  respond_to :json

  def index
    headers['Last-Modified'] = Time.now.httpdate
  	# current_resource_owner = User.find(1)
    @clienti = current_resource_owner.clienti.order(:titolo)
  end

  def show
		# current_resource_owner = User.find(1)
    @cliente = current_resource_owner.clienti.includes(:classi, :appunti => {:righe => :libro}).find(params[:id])
    respond_with @cliente, root: "cliente", :serializer => ClienteAppuntiSerializer
  end
	  
	def create
    @cliente = current_resource_owner.clienti.build(params[:cliente])
    if @cliente.save
      respond_with @cliente#, responder: Api::V1::MyResponder
    end
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
