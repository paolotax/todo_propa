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
# == Schema Information
#
# Table name: causali
#
#  id         :integer         not null, primary key
#  causale    :string(255)
#  magazzino  :string(255)
#  movimento  :string(255)
#  tipo       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

