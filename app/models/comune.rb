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

# == Schema Information
#
# Table name: comuni
#
#  id         :integer         not null, primary key
#  istat      :string(255)
#  comune     :string(255)
#  provincia  :string(255)
#  regione    :string(255)
#  prefisso   :string(255)
#  cap        :string(255)
#  codfisco   :string(255)
#  abitanti   :integer
#  link       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

