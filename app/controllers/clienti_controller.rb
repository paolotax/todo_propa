class ClientiController < ApplicationController
  
  can_edit_on_the_spot
  
  def index
    session[:return_to] = request.path
    @search = current_user.clienti.not_deleted.filtra(params)
    @clienti = @search.page(params[:page]).ordina(params)

    # .includes(:visite, :classi, :mie_adozioni, :appunti)
    
    # stats
    @stat_clienti    = current_user.clienti.not_deleted.per_localita.filtra(params.except(:status))
    @search_appunti  = current_user.appunti.not_deleted.filtra(params.except(:status))
    @in_corso   = @stat_clienti.con_appunti(@search_appunti.in_corso).size
    @da_fare    = @stat_clienti.con_appunti(@search_appunti.da_fare).size
    @in_sospeso = @stat_clienti.con_appunti(@search_appunti.in_sospeso).size 
    @preparati  = @stat_clienti.con_appunti(@search_appunti.preparato).size    
    @tutti      = @stat_clienti.size 
    
    #filters
    @provincie = current_user.clienti.not_deleted.select_provincia.filtra(params.except(:provincia).except(:comune)).order(:provincia)
    @citta     = current_user.clienti.not_deleted.select_citta.filtra(params.except(:comune)).order(:comune)


    respond_to do |format|
      format.html
      format.json { render json: @search.ordina(params).all}
    end

  end


  def show

    @cliente = current_user.clienti.includes(:appunti, :fatture, :righe, :visite).find(params[:id])

    respond_to do |format|
      format.html do
        session[:return_to] = request.path

        @adozioni_per_scuola = @cliente.adozioni.joins(:classe).scolastico.order("classi.classe, classi.sezione").group_by(&:libro)

        @righe_da_consegnare = @cliente.righe.da_consegnare.da_fatturare.order("appunto_id desc")

        @righe_da_registrare = @cliente.righe.da_fatturare.order("appunto_id desc")

        @classi_inserter = ClassiInserter.new

        if request.path != cliente_path(@cliente)
          redirect_to @cliente, status: :moved_permanently
        end
      end
      format.json { render json: @cliente }
    end      
  end


  def new
    session[:return_to] = request.referer
    @cliente   = current_user.clienti.build
    @indirizzo  = @cliente.indirizzo
    # @spedizione = @cliente.indirizzo_spedizione
    @direzioni = current_user.clienti.not_deleted.order(:titolo)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cliente }
    end
  end


  def edit
    session[:return_to] = request.referer
    @cliente = current_user.clienti.find(params[:id])

    # per inserimento direzione
    if @cliente.scuola_primaria?
      @direzioni = current_user.clienti.not_deleted.direzioni.where(provincia: @cliente.provincia).order(:comune, :id)
    else
      @direzioni = current_user.clienti.not_deleted.where(provincia: @cliente.provincia).order(:comune, :id)
    end 
  end

  def create
    @cliente = current_user.clienti.build(params[:cliente])

    respond_to do |format|
      if @cliente.save
        format.html { redirect_to session[:return_to], notice: 'Cliente creato.' }
        format.json { render json: @cliente, status: :created, location: @cliente }
      else
        format.html { render action: "new" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @cliente = current_user.clienti.find(params[:id])
    
    respond_to do |format|
      if @cliente.update_attributes(params[:cliente])
        format.html { redirect_to session[:return_to], notice: 'Cliente modificato.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @cliente.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @cliente = current_user.clienti.find(params[:id])
    @cliente.destroy

    respond_to do |format|
      format.html { redirect_to clienti_url }
      format.json { head :ok }
    end
  end

  def import
    Cliente.import(params[:file], current_user)
    redirect_to clienti_url, notice: "Clienti Importati."
  end

  def export
    @clienti = current_user.clienti.per_localita
  end

  def propa2014
    @clienti = current_user.clienti.not_deleted.scuole.per_localita

    if params[:provincia]
      @clienti = @clienti.where(provincia: params[:provincia])
    end

    @count_elementari = @clienti.select { |c| c.scuola_primaria? == true}.count
    @provincie = current_user.clienti.not_deleted.direzioni.select_provincia.map(&:provincia)
    #@clienti = current_user.clienti.where(:ancestry => Cliente.roots.pluck(:id)).per_localita
  end
  
  def registra_documento
    @cliente = current_user.clienti.find(params[:id])
    
    @fattura = @cliente.fatture.build(causale_id: params[:causale_id])

    @appunti = current_user.appunti.includes(:righe).find(params[:appunto_ids])
    
    @appunti.each do |a|
      @fattura.righe << a.righe
      if a.stato == 'X'
        @fattura.pagata = true
      else
        @fattura.pagata = false
      end
    end 

    @fattura.numero = 
    @fattura.user_id = current_user.id

    if params[:data_documento] == 'ultima'
      data = @fattura.last_data(current_user, Time.now)
    else
      data = Time.now
    end

    @fattura.data = data
    @fattura.numero = @fattura.last_numero(current_user, Time.now) + 1
    
    
    respond_to do |format|
      if @fattura.save
        format.html { redirect_to fatture_url }
        format.json { head :ok }
      else
        raise "GINO".inspect
      end
    end   
    #raise @fattura.righe.inspect  
  end


  def sposta_righe
    
    @cliente = current_user.clienti.find(params[:id])
    @cliente.crea_consegna(params[:riga_ids]) 
    redirect_to :back  
  end


  def scorri_classi

    @cliente = current_user.clienti.find(params[:id])

    
    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      c.classe += 1
      c.anno = Time.now.year.to_s
      c.save    
    end
    
    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      if c.classe == 6
        c.classe = 1
        c.save
      end
    end

    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      
      c.adozioni.each do |old| 

        seguito = old.try(:libro).try(:seguito)
        
        if seguito.nil?
          old.destroy
        else
          old.libro = seguito
          old.materia_id = seguito.materia_id
          old.save
        end

        seguito = nil
      end
    end

    respond_to do |format|
      format.html { redirect_to :back}
      format.js
    end
       
  end 


  def scorri_classi_gelmini

    @cliente = current_user.clienti.find(params[:id])

    old_adozioni = []

    @cliente.mie_adozioni.each do |a|
      old_adozioni << { libro_id: a.libro_id, classe: a.classe.classe, sezione: a.classe.sezione, kit_1: a.kit_1, kit_2: a.kit_2 }
      a.destroy
    end
    
    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      c.classe += 1
      c.anno = Time.now.year.to_s
      c.save    
    end
    
    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      if c.classe == 6
        c.classe = 1
        c.save
      end
    end

    @cliente.classi.order("classi.classe desc, classi.sezione desc").each do |c|
      old_adozioni.select do |old| 
        old[:classe] == c.classe && old[:sezione] == c.sezione
      end.each do |ado|
        c.adozioni.create!(
          libro_id: ado[:libro_id],
          nr_copie: c.nr_alunni,
          nr_sezioni: 1,
          kit_1: ado[:kit_1],
          kit_2: ado[:kit_2]
        )
      end
    end

    respond_to do |format|
      format.html { redirect_to :back}
      format.js
    end
       
  end  
    

end
