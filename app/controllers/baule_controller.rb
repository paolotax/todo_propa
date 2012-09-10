class BauleController < ApplicationController
  def show
    @visite  = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).order(:cliente_id).nel_baule
    @clienti = @visite.map(&:cliente)

    righe   = current_user.righe.da_consegnare.joins(:libro, :appunto => :visite).where('visite.baule = true')
    @libri_nel_baule   = righe.order("libri.titolo").group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, image: libro.image, quantita: righe.sum(&:quantita) }
    end
    
    adozioni = current_user.mie_adozioni.includes(:libro).joins(:classe).where("classi.cliente_id in (?)", @clienti.map(&:id)).order("libri.titolo")
    @adozioni_nel_baule =  adozioni.group_by(&:libro).map do |libro,adozioni|
      { image: libro.image_url(:small_thumb), titolo: libro.titolo, image: libro.image, quantita: adozioni.count(&:classe) }
    end
  end

  def destroy
    @visite = current_user.visite.nel_baule
    @visite.each do |v|
      v.destroy
    end

    respond_to do |format|
      format.html { redirect_to visite_path, notice: "Baule svuotato" }
    end
  end
  
  def update

    @visite = current_user.visite.nel_baule
    @visite.each_with_index do |a, index|
      a.update_attributes!(params[:visita].merge(step: index).reject { |k,v| v.blank? })  #  unless k == 'stato'
    end
    
    respond_to do |format|
      format.html { redirect_to visite_path, notice: "Il giro e' stato salvato" }
    end
  end

end
