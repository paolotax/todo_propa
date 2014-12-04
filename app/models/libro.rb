class Libro < ActiveRecord::Base


  SETTORI     = ["Scolastico", "Fascicoli", "Parascolastico", "Vacanze", "Varia", "Eventuale", "Guide", "Adozionale", "Concorrenza", "Scorrimento"]
  
  
  extend FriendlyId
  friendly_id :titolo, use: [:slugged, :history]

  
  mount_uploader :image, ImageUploader

  
  include PgSearch
  pg_search_scope :search, against: [:titolo, :settore, :sigla, :cm, :ean],
    using: { tsearch: { dictionary: "italian", prefix: true } }


  has_and_belongs_to_many :children, join_table: "libro_connections", class_name: "Libro", foreign_key: :libro_parent_id, association_foreign_key: :libro_child_id

  has_and_belongs_to_many :parents, join_table: "libro_connections", class_name: "Libro", foreign_key: :libro_child_id, association_foreign_key: :libro_parent_id
  
  has_one :seguito, class_name: "Libro", foreign_key: :id, primary_key: :next_id

  
  has_many :righe,    dependent: :nullify
  has_many :adozioni, dependent: :nullify

  
  belongs_to :editore
  belongs_to :materia

  
  delegate :nome, :gruppo, to: :editore
  delegate :materia_libro, to: :materia

  
  scope :per_classe_e_materia, lambda {
                                  |cl,mat| joins(:adozioni => :classe).
                                           select('distinct libri.*').
                                           where('classi.classe = ?', cl).
                                           where('adozioni.materia_id = ?', mat) }
    
  scope :per_settore, unscoped.order(:settore)
  scope :per_titolo,  unscoped.order(:titolo)

  scope :adottabile_per_classe, lambda { |p| adottabile.where( classe: p) }  

  scope :adottabile, where("libri.settore in ('Concorrenza', 'Scolastico')").order("libri.classe, libri.materia_id, libri.settore DESC, libri.titolo")
  
  scope :seguiti, where("libri.settore in ('Concorrenza', 'Scolastico')").order(:titolo)

  scope :vendibili, where("libri.settore <> 'Concorrenza'").where("libri.settore <> 'Scorrimento'").where("libri.settore <> 'Adozionale'")

  scope :previous, lambda { |i, f| where("#{self.table_name}.#{f} < ?", i[f]).order("#{self.table_name}.#{f} DESC").limit(1) }
  scope :next,     lambda { |i, f| where("#{self.table_name}.#{f} > ?", i[f]).order("#{self.table_name}.#{f} ASC").limit(1) }
  
  scope :anagrafica_da_completare, where("libri.settore is null")
  

  def to_s
    titolo
  end

  
  def self.cached_find(id)
    Rails.cache.fetch([name, id]) { find(id) }
  end


  def flush_cache
    Rails.cache.delete([self.class.name, id])
  end
  
  
  SETTORI.each do |settore|
    scope "#{settore.downcase}", where("libri.settore = ?", settore)

    define_method "#{settore.split.join.underscore}?" do
      self.settore == settore
    end
  end
  

  def anagrafica_da_completare?
    self.settore == nil
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

    # per #classi_inserter_libri
    libri = libri.adottabile_per_classe(params[:adottabile_per_classe]) if params[:adottabile_per_classe].present?

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

