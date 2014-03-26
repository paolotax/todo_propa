class Propa2014 < ActiveRecord::Base

  belongs_to :cliente

  validates :cliente_id, uniqueness: true

  

end
