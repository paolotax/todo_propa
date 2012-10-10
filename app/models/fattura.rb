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
  
  def self.filtra(params)
    fatture = scoped
    fatture = fatture.search(params[:search]) if params[:search].present?
    fatture = fatture.where("causale_id = ?", TIPO_FATTURA.index(params[:causale])) if params[:causale].present?
    fatture = fatture.where("extract(year  from data) = ? ", params[:anno] ) if params[:anno].present?
    fatture = fatture.where("condizioni_pagamento = ?", params[:pagamento]) if params[:pagamento].present?
    fatture
    # raise fatture.inspect  if params[:search].present?
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
    status == 'active'
  end
  
  def add_righe_from_cliente(cliente) 
    cliente.righe.da_fatturare.each do |riga|
      self.totale_copie += riga.quantita || 0
      self.importo_fattura += riga.quantita * riga.prezzo_unitario || 0
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
  
  def add_righe_from_appunto(appunto)
    self.totale_copie = self.totale_copie || 0
    self.importo_fattura = self.importo_fattura || 0.0
    appunto.righe.each do |riga|
      self.totale_copie += riga.quantita
      self.importo_fattura += riga.quantita * riga.prezzo_unitario
      self.righe << riga
    end
  end

  def ricalcola
    self.totale_copie    = righe.map(&:quantita).sum
    self.importo_fattura = righe.map(&:importo).sum
    self.totale_iva = 0 
    righe.each do |r|
      unless r.libro.iva == "VA"
        self.totale_iva += r.importo / 100 * r.libro.iva.to_f
      end
    end 
  end
    
  def get_new_id(user)
    last_id = Fattura.where("user_id = ? and data >= ? and causale_id = ?", user.id, Time.now.beginning_of_year, self.causale_id).order('numero desc').limit(1)
    if last_id.empty?
      return 1
    else
      return last_id[0][:numero] + 1    
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

