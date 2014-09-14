class VisiteController < ApplicationController
  
  
  def index

    @visite = current_user.visite.settembre.includes(:cliente => :visite).where(baule: false).filtra(params)
    
    @visite_grouped = @visite.order("start desc").group_by {|v| "#{v.to_s}" }
    
    @nel_baule      = current_user.clienti.nel_baule.filtra(params.except([:controller, :action]))
    @scuole_fatte   = current_user.clienti.scuola_primaria.con_visite(Visita.settembre).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    @scuole_da_fare = current_user.clienti.scuola_primaria.senza_visite(Visita.settembre).con_adozioni(Adozione.joins(:classe).scolastico).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
    
    @altri_clienti = current_user.clienti.con_appunti(Appunto.in_corso).senza_adozioni(Adozione.joins(:classe).scolastico).includes(:appunti, :visite).filtra(params.except([:controller, :action])).order("clienti.id")
        
    respond_to do |format|
      format.html
      format.json { render :rabl => @visite }
    end
    
  end
  
  
  def create
    
    @visita = current_user.visite.build(params[:visita])

    respond_to do |format|
      if @visita.save
        format.html { redirect_to :back, :notice => 'Visita pianificata.' }
        format.js
        format.json { render :json => @visita, :status => :created, :location => @visita }
      else
        format.html { render :action => "new" }
        format.json { render :json => @visita.errors, :status => :unprocessable_entity }
      end
    end
  end

  
  def update
    
    @visita = current_user.visite.find(params[:id])
    respond_to do |format|
      if @visita.update_attributes(params[:visita])
        format.html { redirect_to :back, notice: 'Visita modificata.' }
        format.js
        format.json { render json: @visita }
      else
        format.html { render action: "edit" }
        format.json { render json: @visita.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    
    @visita = current_user.visite.find(params[:id])
    @cliente = @visita.cliente
    @appunti = @cliente.appunti.in_corso
    @giro  = Giro.new(user: current_user, giorno: @visita.data, baule: @visita.baule)
    
    @visita.destroy
    respond_to do |format|
      format.html { redirect_to :back, :notice => 'Visita eliminata.' }
      format.js
    end
  end


  def update_all
  end
  
  
  def destroy_all
    @visite = current_user.visite.destroy(params[:visite][:visita_ids])

    respond_to do |format|
      format.html { redirect_to :back }
      format.js
      format.json { head :no_content }
    end
  end


  def sort

    # params data non serve nell update all ma il giorno è sbagliato
    if params[:data]
      data = DateTime.parse(params[:data])
    else
      data = DateTime.now.beginning_of_day
    end

    params[:visita].each_with_index do |id, index|
      current_user.visite.update_all({start: data + (index+1).hour}, {id: id})
    end
    
    render nothing: true
  end


end
