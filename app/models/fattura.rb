class Fattura < ActiveRecord::Base

  TIPO_FATTURA = [ "Fattura", "Buono di consegna", "Nota di accredito" ]
  TIPO_PAGAMENTO = ["Contanti", "Assegno", "Bonifico Bancario", "Bollettino Postale"]
  
  # extend FriendlyId
  # friendly_id :doc_id, use: [:slugged, :history]
  
  
  belongs_to :cliente
  belongs_to :user
  
  has_many :righe, :dependent => :nullify
  has_many :appunti, :through => :righe
  
  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => false
  
  
  
  validates :cliente_id, :data, :numero, :presence => true, :if => :active?
  
  scope :per_numero, order('fatture.data desc, fatture.numero desc')
  
  before_save :ricalcola
  
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
    "#{data.year}-#{numero}"
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
  end
    
  def get_new_id(user)
    
    last_id = Fattura.where("user_id = ? and data > ?", user.id, Time.now.beginning_of_year).order('numero desc').limit(1)
    
    if last_id.empty?
      return 1
    else
      return last_id[0][:numero] + 1    
    end
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

