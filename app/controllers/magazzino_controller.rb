class MagazzinoController < ApplicationController
  
  def vendite
    
    @da_consegnare = current_user.righe.includes(:libro, :appunto).da_consegnare.order("libri.titolo").group_by(&:libro)
    
    @in_ordine     = current_user.righe_fattura.joins(:fattura).where("fatture.causale_id = ?", 3).group_by(&:libro)
    
    
    
  end
  
end
