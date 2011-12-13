class Libro < ActiveRecord::Base
  
  has_many :righe
  
  mount_uploader :image, ImageUploader
  
  scope :per_titolo, unscoped.order(:titolo)
  scope :vendibili, where("libri.type <> 'Concorrenza'").where("libri.type <> 'Scorrimento'")
  
  def self.inherited(child)
    child.instance_eval do
      def model_name
        Libro.model_name
      end
    end
    super
  end
  
  #fratelli usato per option group
  def bros
    Libro.unscoped.where("type = ?", self.type).order(:titolo)
  end
  
end
