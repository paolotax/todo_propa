class Libro < ActiveRecord::Base
  has_many :righe
  
  scope :per_titolo, unscoped.order(:titolo)
  scope :vendibili, where("libri.type <> 'Concorrenza'").where("libri.type <> 'Scorrimento'")
  
  #fratelli usato per option group
  def bros
    Libro.unscoped.where("type = ?", self.type).order(:titolo)
  end
  
end
