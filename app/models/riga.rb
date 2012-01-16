class Riga < ActiveRecord::Base
  belongs_to :appunto
  belongs_to :libro

  after_initialize :init
  after_save :ricalcola_totali
  after_destroy :ricalcola_totali


  delegate :titolo, :prezzo_copertina, :prezzo_consigliato, :to => :libro

  scope :per_libro_id, order("righe.libro_id")
  
    
  def prezzo
    prezzo_unitario
  end
  
  def prezzo=(text)
    self.prezzo_unitario = text
  end
  
  def importo
    sconto.nil? ? sc = 0.0 : sc = sconto
    prezzo_unitario * quantita * (100.0 - sc) / 100
  end

  private

    def init
      self.sconto ||= 0.0           #will set the default value only if it's nil
    end  
  
    def ricalcola_totali
      return true unless quantita_changed? || prezzo_unitario_changed? || fattura_id_changed? || sconto_changed?
      appunto.update_attributes(:totale_copie => appunto.righe.sum(:quantita), :totale_importo => appunto.righe.sum('righe.quantita * righe.prezzo_unitario * (100 - righe.sconto) / 100'))
      return true
    end

end
