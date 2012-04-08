class Materia < ActiveRecord::Base
  
  has_many :adozioni, dependent: :nullify
  has_many :libri, :through => :adozioni, dependent: :nullify
  
end
