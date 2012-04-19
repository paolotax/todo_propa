class BauleController < ApplicationController
  def show
    @visite  = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).order(:cliente_id).nel_baule
    @clienti = @visite.map(&:cliente)

    @righe   = current_user.righe.da_consegnare.joins(:libro, :appunto => :visite).where('visite.baule = true')
    
    
    @libri_nel_baule   = @righe.order("libri.titolo").group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, image: libro.image, quantita: righe.sum(&:quantita) }
    end
    
    @adozioni = Adozione.scolastico.includes(:libro).joins(:classe).where("classi.cliente_id in (?)", @clienti.map(&:id)).order("libri.titolo")
    
    logger.debug { "tutte Count: AAAAAAA" }
        
    @adozioni_nel_baule =  @adozioni.group_by(&:libro).map do |libro,adozioni|
      { image: libro.image_url(:small_thumb), titolo: libro.titolo, image: libro.image, quantita: adozioni.count(&:classe) }
    end
    
    @scuole = current_user.clienti.primarie.order("clienti.id").all
    @visite_all = current_user.visite.includes(:cliente)
    @visite_all.each do |v|
      @scuole.delete(v.cliente)
    end

  end
  
  def destroy
    @visite = current_user.visite.nel_baule
      
    @visite.each do |v|
      v.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to baule_path }
    end
      
  end
  
  def update
    #raise params.inspect
    @visite = current_user.visite.nel_baule
   
    @visite.each do |a|
      a.update_attributes!(params[:visita].reject { |k,v| v.blank? })  #  unless k == 'stato'
    end
    
    respond_to do |format|
      format.html { redirect_to baule_path, notice: "Baule aggiornato" }
      format.json { render :json => @appunti }
    end
  end
  
  
end
