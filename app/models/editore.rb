class Editore < ActiveRecord::Base

  has_many :libri


  scope :concorrenza, where("gruppo <> 'GIUNTI' or gruppo is null").order(:nome)


  def to_s
    nome
  end 
  
end
