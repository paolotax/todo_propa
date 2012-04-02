class BauleController < ApplicationController
  def show
    @visite = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).nel_baule
    @clienti = @visite.map(&:cliente)
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
