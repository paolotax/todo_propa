class MagazzinoController < ApplicationController
  
  def vendite
    
    @da_consegnare = current_user.righe.joins(:libro).da_consegnare.order("libri.titolo").group_by(&:libro)
    
  end
  
end
