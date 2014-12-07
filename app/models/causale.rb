class Causale < ActiveRecord::Base

  has_many :fatture


  scope :carico,  where("causali.tipo = 'carico'")
  scope :scarico, where("causali.tipo = 'scarico'")

  def carico?
    tipo == "carico"
  end

  def scarico?
    tipo == "scarico"
  end
  
end
