class BauleController < ApplicationController
  def show
    @visite  = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).nel_baule
    @clienti = @visite.map(&:cliente)
    
    @righe   = current_user.righe.da_consegnare.joins(:libro, :appunto => :visite).where('visite.baule = true')
    @libri_nel_baule = @righe.group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, image: libro.image, copie: righe.sum(&:quantita) }
    end
    
  end
  
  def destroy
    @visite = current_user.visite.nel_baule
      
    @visite.each do |v|
      v.destroy
    end
    
    respond_to do |format|
      format.html { redirect_to appunti_path }
    end
      
  end
end
