class Libro < ActiveRecord::Base


  SETTORI     = ["Scolastico", "Parascolastico", "Vacanze", "Varia", "Eventuale", "Concorrenza", "Scorrimento"]
  SETTORI_OPT = [
                  ["Scolastico", "Scolastico"], 
                  ["Parascolastico", "Parascolastico"], 
                  ["Vacanze", "Vacanze"], 
                  ["Varia", "Varia"], 
                  ["Eventuale", "Eventuale"], 
                  ["Concorrenza", "Concorrenza"], 
                  ["Scorrimento", "Scorrimento"]
                ]

  extend FriendlyId
  friendly_id :titolo
  
  has_many :righe
  
  mount_uploader :image, ImageUploader
  
  scope :per_settore, unscoped.order(:settore)
  scope :per_titolo, unscoped.order(:titolo)
  
  scope :vendibili, where("libri.settore <> 'Concorrenza'").where("libri.settore <> 'Scorrimento'")
  
  #fratelli usato per option group
  def bros
    Libro.unscoped.where("settore = ?", self.settore).order(:titolo)
  end
  
  def carica_image_da_giunti
    self.remote_image_url = "http://catalogo.giunti.it/librig/#{self.cm}.jpg"
  end
end


