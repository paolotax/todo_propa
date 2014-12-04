class Causale < ActiveRecord::Base

  has_many :fatture


  scope :carico,  where("causali.tipo = 'carico'")
  scope :scarico, where("causali.tipo = 'scarico'")
  
end
