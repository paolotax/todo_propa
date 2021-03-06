class Libro < ActiveRecord::Base


  SETTORI     = ["Scolastico", "Parascolastico", "Vacanze", "Varia", "Eventuale", "Guide", "Adozionale", "Concorrenza", "Scorrimento"]
  SETTORI_OPT = [
                  ["Scolastico", "Scolastico"], 
                  ["Parascolastico", "Parascolastico"], 
                  ["Vacanze", "Vacanze"], 
                  ["Varia", "Varia"], 
                  ["Eventuale", "Eventuale"], 
                  ["Guide", "Guide"],
                  ["Adozionale", "Adozionale"],
                  ["Concorrenza", "Concorrenza"], 
                  ["Scorrimento", "Scorrimento"]
                ]

  extend FriendlyId
  friendly_id :titolo, use: [:slugged, :history]
  
  has_many :righe
  has_many :adozioni, dependent: :nullify
  
  #default_scope order("libri.id")  
  scope :per_classe_e_materia, lambda {
                                  |cl,mat| joins(:adozioni => :classe).
                                           select('distinct libri.*').
                                           where('classi.classe = ?', cl).
                                           where('adozioni.materia_id = ?', mat) }
  
  mount_uploader :image, ImageUploader
  
  scope :per_settore, unscoped.order(:settore)
  scope :per_titolo,  unscoped.order(:titolo)
  
  scope :vendibili, where("libri.settore <> 'Concorrenza'").where("libri.settore <> 'Scorrimento'").where("libri.settore <> 'Adozionale'")
  
  scope :previous, lambda { |i, f| where("#{self.table_name}.#{f} < ?", i[f]).order("#{self.table_name}.#{f} DESC").limit(1) }
  scope :next,     lambda { |i, f| where("#{self.table_name}.#{f} > ?", i[f]).order("#{self.table_name}.#{f} ASC").limit(1) }
  
  
  #fratelli usato per option group
  def bros
    Libro.unscoped.where("settore = ?", self.settore).order(:titolo)
  end
  
  def carica_image_da_giunti
    self.remote_image_url = "http://catalogo.giunti.it/librig/#{self.cm}.jpg"
  end
  

end


# == Schema Information
#
# Table name: libri
#
#  id                 :integer         not null, primary key
#  autore             :string(255)
#  titolo             :string(255)
#  sigla              :string(255)
#  prezzo_copertina   :decimal(8, 2)
#  prezzo_consigliato :decimal(8, 2)
#  coefficente        :decimal(2, 1)
#  cm                 :string(255)
#  ean                :string(255)
#  old_id             :string(255)
#  settore            :string(255)
#  materia_id         :integer
#  image              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

