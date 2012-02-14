class Cliente < ActiveRecord::Base
  
  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']
  ABBR_TIPI    = ['E', 'IC', 'D', 'C', '', '', 'Com']
  
  # extend FriendlyId
  # friendly_id :nome

  belongs_to :user

  has_many :appunti, dependent: :destroy
  has_many :visite,  dependent: :destroy
  has_many :indirizzi, :as => :indirizzable, :dependent => :destroy
  
  accepts_nested_attributes_for :indirizzi,  :reject_if => lambda {|a| a[:citta].nil? || a[:provincia].nil?}, :allow_destroy => true  
  
  validates :nome,  :presence => true,
                    :uniqueness => { :scope => :user_id, :message => "gia' utilizzato!" }
  
  validates :citta,        :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  validates :cliente_tipo, :inclusion => {:in => TIPI_CLIENTI }
  
  scope :select_provincia, select(:provincia).uniq
  scope :select_citta,     select(:citta).uniq
  
  scope :con_appunti_in_corso,   joins(:appunti).where("appunti.stato <> 'X'")
  scope :con_appunti_completo,   joins(:appunti).where("appunti.stato = 'X'")
  scope :con_appunti_da_fare,    joins(:appunti).where("appunti.stato = ''")
  scope :con_appunti_in_sospeso, joins(:appunti).where("appunti.stato = 'P'")

  scope :scuole,     where("clienti.cliente_tipo in ('Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica')")
  scope :primarie,   where(cliente_tipo: "Scuola Primaria")
  scope :cartolerie, where(cliente_tipo: "Cartolibreria")
  scope :direzioni,  where("clienti.cliente_tipo in ('Istituto Comprensivo', 'Direzione Didattica')")
  scope :altri,      where("clienti.cliente_tipo in ('Persona Fisica', 'Ditta', 'Comune')")

  scope :previous, lambda { |i, f| where("#{self.table_name}.user_id = ? AND #{self.table_name}.#{f} < ?", i.user_id, i[f]).order("#{self.table_name}.#{f} DESC").limit(1) }
  scope :next,     lambda { |i, f| where("#{self.table_name}.user_id = ? AND #{self.table_name}.#{f} > ?", i.user_id, i[f]).order("#{self.table_name}.#{f} ASC").limit(1) }
  
  
  #after_initialize :set_indirizzi
  
  before_save :set_nome
  
  # TIPI_CLIENTI.each do |tc|
  #   define_method '#{cliente_tipo}?' do
  #     self.cliente_tipo == tc
  #   end
  # end
  # 
  # class << self
  #   TIPI_CLIENTI.each do |tc|
  #     define_method '#{cliente_tipo}' do
  #       cliente_tipo
  #     end
  #   end
  # end  
  
  def to_s
    "##{id} - #{nome} #{citta} (#{provincia})"
  end
  
  def indirizzo
    ind = self.indirizzi.where(tipo: "Indirizzo fattura").last
    ind ||= self.indirizzi.build(tipo: 'Indirizzo fattura')
  end
  
  def indirizzo_spedizione
    ind = self.indirizzi.where(tipo: "Indirizzo spedizione").last
    ind ||= self.indirizzo
  end
  
  def latitude
    self.indirizzo.latitude
  end
  
  def longitude
    self.indirizzo.longitude
  end
  
  def comune
    citta
  end
  
  def comune=(text)
    self.citta = text
  end
  
  def self.filtra(params)

    clienti = scoped
    clienti = clienti.where("clienti.nome ilike ?  or clienti.citta ilike ?", 
                          "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    clienti = clienti.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    clienti = clienti.where("clienti.citta = ?",     params[:citta])     if params[:citta].present?

    clienti = clienti.scuole     if params[:tipo].present? && params[:tipo] == 'scuole'
    clienti = clienti.primarie   if params[:tipo].present? && params[:tipo] == "primarie"
    clienti = clienti.cartolerie if params[:tipo].present? && params[:tipo] == "cartolerie"
    clienti = clienti.direzioni  if params[:tipo].present? && params[:tipo] == "direzioni"
    clienti = clienti.altri      if params[:tipo].present? && params[:tipo] == "altri"

    clienti = clienti.joins(:appunti).con_appunti_in_corso   if params[:status].present? && params[:status] == 'in_corso'
    clienti = clienti.joins(:appunti).con_appunti_completo   if params[:status].present? && params[:status] == "completati"
    clienti = clienti.joins(:appunti).con_appunti_da_fare    if params[:status].present? && params[:status] == "da_fare"
    clienti = clienti.joins(:appunti).con_appunti_in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    clienti
  end
  
private

  def set_indirizzi
    self.indirizzi.build(tipo: 'Indirizzo fattura') unless self.indirizzo.present?
    self.indirizzi.build(tipo: 'Indirizzo spedizione') unless self.indirizzo_spedizione.present?
  end
  
  def set_nome
    n = self.nome.split(' ')
    suff = Cliente::ABBR_TIPI[Cliente::TIPI_CLIENTI.index(self.cliente_tipo)]
    
    unless n[0] == suff
      self.nome = suff + " " + self.nome
    end
  end

end
