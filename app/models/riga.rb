class Riga < ActiveRecord::Base
  belongs_to :appunto
  belongs_to :libro
  
  
  def prezzo
    prezzo_unitario
  end
  
  def prezzo=(text)
    self.prezzo_unitario = text
  end
end
