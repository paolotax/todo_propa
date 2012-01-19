class Comune < ActiveRecord::Base

  scope :ordine_per_comune, order(:comune)
  
  scope :provincie, select('DISTINCT provincia').order(:provincia)

  scope :per_provincia, lambda { |p| where( :provincia => p) }  

  #fratelli usato per option group
  def bros
    Comune.unscoped.where("provincia = ?", self.provincia).order(:comune)
  end
  
  def citta
    comune
  end
end
