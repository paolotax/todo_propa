class Editore < ActiveRecord::Base

  has_many :libri


  scope :concorrenza, where("gruppo <> 'GIUNTI' or gruppo is null").order(:nome)


  def to_s
    nome
  end 
  
end
# == Schema Information
#
# Table name: editori
#
#  id         :integer         not null, primary key
#  nome       :string(255)
#  gruppo     :string(255)
#  codice     :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

