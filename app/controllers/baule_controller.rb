class BauleController < ApplicationController
  def show
    
    @visite = current_user.visite.includes([:cliente, :visita_appunti => [:appunto => [:righe => :libro]]]).nel_baule
    
    @clienti = @visite.map(&:cliente)
    
  end
end
