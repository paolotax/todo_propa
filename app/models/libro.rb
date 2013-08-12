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
  scope :vacanze,   where("libri.settore = 'Vacanze'").order(:titolo) 
  scope :scolastico,   where("libri.settore = 'Scolastico'")
  scope :vendibili, where("libri.settore <> 'Concorrenza'").where("libri.settore <> 'Scorrimento'").where("libri.settore <> 'Adozionale'")
  
  scope :previous, lambda { |i, f| where("#{self.table_name}.#{f} < ?", i[f]).order("#{self.table_name}.#{f} DESC").limit(1) }
  scope :next,     lambda { |i, f| where("#{self.table_name}.#{f} > ?", i[f]).order("#{self.table_name}.#{f} ASC").limit(1) }
  
  
  SETTORI.each do |settore|
    scope "#{settore.downcase}", where("libri.settore = ?", settore)

    define_method "#{settore.split.join.underscore}?" do
      self.settore == settore
    end
  end
  
  #fratelli usato per option group
  def bros
    Libro.unscoped.where("settore = ?", self.settore).order(:titolo)
  end
  
  def carica_image_da_giunti
    self.remote_image_url = "http://catalogo.giunti.it/librig/#{self.cm}.jpg"
  end
  
  after_save :load_into_soulmate
  
  def self.search_mate(term)
    matches = Soulmate::Matcher.new("libro").matches_for_term(term)
  end
  
  def load_into_soulmate
    loader = Soulmate::Loader.new("libro")
    loader.add({
                  "term" => "#{titolo} #{sigla} #{cm} #{ean} #{settore}".squish, 
                  "id" => id, 
                  "data" => { 
                    "url" => "libri/#{slug}",
                    "titolo" => titolo, 
                    "codici" => "#{cm} #{ean}".squish,
                    "tags"   => "#{settore} #{sigla}"
                  }
                })
  end

  def self.filtra(params)
    libri = scoped
    libri = libri.search(params[:search]) if params[:search].present?
    if params[:settore].present?
      libri = libri.try(params[:settore].downcase)
    end
    libri
  end
  
  def self.ordina(params)
    libri = scoped
    unless params[:ordine].present?
      libri = libri.per_titolo
    else
      # libri = libri.joins(:cliente).order('clienti.titolo, libri.created_at desc') if params[:ordine] == "cliente"

      # libri = libri.joins(:cliente).order('clienti.provincia, clienti.comune, clienti.titolo, libri.created_at desc') if params[:ordine] == "comune"

      # libri = libri.order('cliente_id, appunti.created_at desc') if params[:ordine] == "cliente_id"
    end 
    libri
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

