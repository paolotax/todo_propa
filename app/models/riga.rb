class Riga < ActiveRecord::Base
  belongs_to :appunto
  belongs_to :libro
  
  
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
end
