class DocumentiRiga < ActiveRecord::Base


  belongs_to :documento
  belongs_to :riga


  after_create   :increment_documento
  before_destroy :decrement_documento

  
  def increment_documento
    unless documento.nil?
      logger.debug "---increment_documento---"      
      Documento.update_counters documento.id,  
        totale_importo: riga.importo,
        totale_copie: riga.quantita
    end
    return true
  end

  
  def decrement_documento
    unless documento.nil?
      logger.debug "---decrement_documento---"
      Documento.update_counters documento.id,  
        totale_importo: - riga.importo,
        totale_copie: - riga.quantita
      riga.annulla_registra
    end
    return true
  end 

end# == Schema Information
#
# Table name: documenti_righe
#
#  id           :integer         not null, primary key
#  documento_id :integer
#  riga_id      :integer
#

