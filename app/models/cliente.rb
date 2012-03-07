class Cliente < ActiveRecord::Base
  
  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']
  ABBR_TIPI    = ['E', 'IC', 'D', 'C', '', '', 'Com']
  
  # extend FriendlyId
  # friendly_id :nome

  belongs_to :user

  has_many :appunti, dependent: :destroy
  has_many :visite,  dependent: :destroy
  has_many :indirizzi, :as => :indirizzable, :dependent => :destroy
  
  accepts_nested_attributes_for :indirizzi,  :reject_if => lambda {|a| a[:comune].nil? || a[:provincia].nil?}, :allow_destroy => true  
  
  validates :titolo,  :presence => true,
                      :uniqueness => { :scope => :user_id, :message => "gia' utilizzato" }

  validates :comune,       :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  validates :cliente_tipo, :inclusion => {:in => TIPI_CLIENTI, :message => "non hai scelto il tipo cliente" }
  
  scope :select_provincia, select(:provincia).uniq
  scope :select_citta,     select(:comune).uniq
  
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
  
  before_save :set_titolo
  
  TIPI_CLIENTI.each do |tc|
    define_method '#{cliente_tipo}?' do
      self.cliente_tipo == tc
    end
  end
  
  class << self
    TIPI_CLIENTI.each do |tc|
      define_method '#{cliente_tipo}' do
        cliente_tipo
      end
    end
  end  
  
  def to_s
    "##{id} - #{titolo} #{frazione} #{comune} (#{provincia})"
  end
  
  # def indirizzo
  #   ind = self.indirizzi.where(tipo: "Indirizzo fattura").last
  #   ind ||= self.indirizzi.build(tipo: 'Indirizzo fattura')
  # end
  # 
  # def indirizzo_spedizione
  #   ind = self.indirizzi.where(tipo: "Indirizzo spedizione").last
  #   ind ||= self.indirizzo
  # end

  def set_indirizzi
    # self.indirizzi.build(tipo: 'Indirizzo fattura') unless self.indirizzo.present?
    # self.indirizzi.build(tipo: 'Indirizzo spedizione') unless self.indirizzo_spedizione.present?
  end

  def self.filtra(params)

    clienti = scoped
    clienti = clienti.where("clienti.nome ilike ?  or clienti.comune ilike ? or clienti.frazione ilike ?", 
                          "%#{params[:search]}%", "%#{params[:search]}%", "#{params[:search]}%") if params[:search].present?
    clienti = clienti.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    clienti = clienti.where("clienti.comune = ?",     params[:comune])     if params[:comune].present?

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
  
  geocoded_by :full_street_address
  
  # after_validation :geocode, 
  #                        :if => lambda{ |obj| obj.indirizzo_changed? || obj.cap_changed? || obj.citta_changed? || obj.cap_changed? || obj.indirizzable.citta_changed? }

  def full_street_address
    [self.indirizzo, self.cap, self.frazione, self.comune, self.provincia].join(', ')
  end
  
  acts_as_gmappable
  
  def gmaps4rails_address
    "#{self.indirizzo}, #{self.frazione}, #{self.comune}, #{self.cap}, #{self.provincia}"
  end
  
  def gmaps4rails_infowindow
    "#{self.titolo} </br> #{self.frazione} #{self.comune}"
  end
  
  def calculate_tipo_from_titolo
    if ( self.titolo =~ /^E\s.+/)
      self.cliente_tipo = "Scuola Primaria"
    elsif ( self.titolo =~ /^D\s.+/ )
      self.cliente_tipo = "Direzione Didattica"
    elsif ( self.titolo =~ /^C\s.+/ )
      self.cliente_tipo = "Cartolibreria"
    elsif ( self.titolo =~ /^IC\s.+/ )
      self.cliente_tipo = "Istituto Comprensivo"
    elsif ( self.titolo =~ /(^G\s.+)|(^P\s.+)/ )
      self.cliente_tipo = "Persona Fisica"
    elsif ( self.titolo =~ /^Z\s.+/ )
      self.cliente_tipo = "Ditta"
    end
    self.save
  end
  
  private
  
    def set_titolo
      n = self.titolo.split(' ')
      suff = Cliente::ABBR_TIPI[Cliente::TIPI_CLIENTI.index(self.cliente_tipo)]
      
      unless n[0] == suff
        self.titolo = suff + " " + self.titolo
      end
    end

end


