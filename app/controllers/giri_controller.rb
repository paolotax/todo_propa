class GiriController < ApplicationController
  
  def show
    
    
    @visite  = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).order(:cliente_id).where("date(start) = ?", params[:giorno])
    @clienti = @visite.map(&:cliente)

    righe   = current_user.righe.da_consegnare.joins(:libro, :appunto => :visite).where("date(start) = ?", params[:giorno])
    @libri_nel_baule   = righe.order("libri.titolo").group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, image: libro.image, quantita: righe.sum(&:quantita) }
    end
    
    adozioni = current_user.mie_adozioni.includes(:libro).joins(:classe).where("classi.cliente_id in (?)", @clienti.map(&:id)).order("libri.titolo")
    @adozioni_nel_baule =  adozioni.group_by(&:libro).map do |libro,adozioni|
      { image: libro.image_url(:small_thumb), titolo: libro.titolo, image: libro.image, quantita: adozioni.count(&:classe) }
    end
    

    
  end
  
end