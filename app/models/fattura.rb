class Fattura < ActiveRecord::Base

  TIPO_FATTURA   = [ "Fattura", "Buono di consegna", "Nota di accredito", "Ordine" ]
  TIPO_PAGAMENTO = ["Contanti", "Assegno", "Bonifico Bancario", "Bollettino Postale"]
  
  extend FriendlyId
  friendly_id :doc_id, use: [:slugged, :history]
  
  
  belongs_to :cliente
  belongs_to :user
  
  has_many :righe, :dependent => :nullify
  has_many :appunti, :through => :righe, uniq: true, order: "appunti.id"
  
  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => false
  
  delegate :titolo, to: :cliente
  
  validates :cliente_id, :data, :numero, :presence => true, :if => :active?
  
  scope :per_numero, order('fatture.data desc, fatture.numero desc')
  
  before_save :ricalcola
  # before_create :init

  # include PgSearch
  # pg_search_scope :search, against: [:slug],
  #   using: {tsearch: {dictionary: "italian"}},
  #   associated_against: {cliente: [ :titolo, :comune, :frazione, :provincia ] },
  #   order_within_rank: "data DESC, numero DESC"
  
  TIPO_FATTURA.each do |tipo|
    scope "#{tipo.downcase.split.join('_')}", where("causale_id = ?", TIPO_FATTURA.index(tipo))
    
    define_method "#{tipo.downcase.split.join('_')}?" do
      self.causale_id == TIPO_FATTURA.index(tipo)
    end
  end
  
  TIPO_PAGAMENTO.each do |tipo|
    scope "#{tipo.downcase.split.join('_')}", where("condizioni_pagamento = ?", tipo)
    
    define_method "#{tipo.downcase.split.join('_')}?" do
      self.condizioni_pagamento == tipo
    end
  end
  
  def pagata?
    pagata
  end
  
  def coerente?
    true
    unless appunti.empty?
      appunti.each do |a|
        return false if a.stato == 'X' && pagata != true
        return false if a.stato == "P" && pagata != false
      end
    else
      true
    end
  end

  def anno
    data.year
  end
  
  def self.filtra(params)
    fatture = scoped
    fatture = fatture.search(params[:search]) if params[:search].present?
    fatture = fatture.where("fatture.causale_id = ?", TIPO_FATTURA.index(params[:causale])) if params[:causale].present?
    fatture = fatture.where("extract(year  from data) = ? ", params[:anno] ) if params[:anno].present?
    fatture = fatture.where("condizioni_pagamento = ?", params[:pagamento]) if params[:pagamento].present?
    fatture = fatture.where("pagata = ?", params[:pagata]) if params[:pagata].present?
    
    fatture
    # raise fatture.inspect  if params[:search].present?
  end


  def self.search(search)
    if search
      fatture = scoped
      fatture = fatture.joins(:cliente).where('clienti.titolo ilike ? or clienti.comune ilike ? or clienti.frazione ilike ? or fatture.slug ilike ?', 
                    "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else        
      scoped
    end
  end

  
  def righe_per_titolo
    self.righe.joins(:libro).order("libri.titolo")
  end
  
  def imponibile
    self.importo_fattura - self.totale_iva
  end
  
  def causale
    unless causale_id.nil?
      TIPO_FATTURA[self.causale_id]
    end
  end
  
  def causale=(text)
    self.causale_id = TIPO_FATTURA.index(text)
  end
  
  
  def active?
    # che cazzo è questo qui
    status == 'active'
  end
  
  def add_righe_from_cliente(cliente)
    self.totale_copie = self.totale_copie || 0
    self.importo_fattura = self.importo_fattura || 0.0 
    cliente.righe.da_fatturare.each do |riga|
      self.totale_copie += riga.quantita || 0
      self.importo_fattura += riga.quantita * riga.prezzo_unitario || 0
      self.righe << riga
    end
  end
  
  def add_righe_from_appunto(appunto)
    self.totale_copie = self.totale_copie || 0
    self.importo_fattura = self.importo_fattura || 0.0
    appunto.righe.each do |riga|
      self.totale_copie += riga.quantita
      self.importo_fattura += riga.quantita * riga.prezzo_unitario
      self.righe << riga
    end
  end

  def doc_id
    if data == nil
      self.id
    else  
      "#{causale}-#{data.year}-#{numero}"
    end
  end 
  

  # ricalcola i totali e cambia stato degli appunti
  def ricalcola
    self.totale_copie    = righe.map(&:quantita).sum
    self.importo_fattura = righe.map(&:importo).sum
    self.totale_iva = 0 
    righe.each do |r|
      unless r.libro.iva == "VA"
        self.totale_iva += r.importo / 100 * r.libro.iva.to_f
      end
    end 
    appunti.each do |a|
      if self.pagata == true
        a.stato = "X"
      else
        a.stato = "P"
      end 
      a.save 
    end
  end
    
  def get_new_id(user)
    last_id = Fattura.where("user_id = ? and data > ? and causale_id = ?", user.id, Time.now.beginning_of_year, self.causale_id).order('numero desc').limit(1)
    if last_id.empty?
      return 1
    else
      return last_id[0][:numero] + 1    
    end
  end

  def last_numero(user, data)
    if causale
      last_numero = Fattura.where("user_id = ? and data > ? and data < ? and causale_id = ?", user.id, data.beginning_of_year, data.end_of_year, causale_id).order('numero desc').limit(1)
      if last_numero.empty?
        return 0
      else
        return last_numero[0][:numero]  
      end
    end    
  end

  def last_data(user, data)
    if causale
      last_data = Fattura.where("user_id = ? and data > ? and data < ? and causale_id = ?", user.id, data.beginning_of_year, data.end_of_year, causale_id).order('numero desc').limit(1)
      if last_data.empty?
        return Time.now
      else
        return last_data[0][:data]  
      end
    end  

  end
  
  private
    
    def init
      self.data ||= self.data = Time.now
    end
end

# == Schema Information
#
# Table name: fatture
#
#  id                   :integer         not null, primary key
#  numero               :integer
#  data                 :date
#  cliente_id           :integer
#  user_id              :integer
#  causale_id           :integer
#  condizioni_pagamento :string(255)
#  pagata               :boolean
#  totale_copie         :integer         default(0)
#  importo_fattura      :decimal(9, 2)
#  totale_iva           :decimal(9, 2)   default(0.0)
#  spese                :decimal(9, 2)   default(0.0)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  slug                 :string(255)
#

