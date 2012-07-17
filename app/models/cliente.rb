class Cliente < ActiveRecord::Base
  
  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']
  ABBR_TIPI    = ['E', 'IC', 'D', 'C', '', '', 'Com']
  
  extend FriendlyId
  friendly_id :titolo, use: [:slugged, :history]

  belongs_to :user

  has_many :appunti, dependent: :destroy
  has_many :fatture, dependent: :destroy
  has_many :visite,  dependent: :destroy
  has_many :indirizzi, :as => :indirizzable, :dependent => :destroy

  has_many :classi,      :dependent => :destroy
  has_many :adozioni, :through => :classi, :include => :libro
  has_many :mie_adozioni, :through => :classi, :source => :adozioni, :include => :libro, :conditions => "libri.settore = 'Scolastico'"
  has_many :righe, through: :appunti

  accepts_nested_attributes_for :indirizzi,  :reject_if => lambda {|a| a[:comune].nil? || a[:provincia].nil?}, :allow_destroy => true  
  
  validates :titolo,  :presence => true,
                      :uniqueness => { :scope => :user_id, :message => "gia' utilizzato" }

  validates :comune,       :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  validates :cliente_tipo, :inclusion => {:in => TIPI_CLIENTI, :message => "non hai scelto il tipo cliente" }
  
  scope :select_provincia, select(:provincia).uniq
  scope :select_citta,     select(:comune).uniq
  
  # scope :con_appunti_in_corso,   joins(:appunti).where("appunti.stato <> 'X'")
  # scope :con_appunti_completo,   joins(:appunti).where("appunti.stato = 'X'")
  # scope :con_appunti_da_fare,    joins(:appunti).where("appunti.stato = ''")
  # scope :con_appunti_in_sospeso, joins(:appunti).where("appunti.stato = 'P'")

  scope :scuole,     where("clienti.cliente_tipo in ('Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica')")
  scope :primarie,   where(cliente_tipo: "Scuola Primaria")
  scope :cartolerie, where(cliente_tipo: "Cartolibreria")
  scope :direzioni,  where("clienti.cliente_tipo in ('Istituto Comprensivo', 'Direzione Didattica')")
  scope :altri,      where("clienti.cliente_tipo in ('Persona Fisica', 'Ditta', 'Comune')")

  scope :previous, lambda { |i, f| where("#{self.table_name}.user_id = ? AND #{self.table_name}.#{f} < ?", i.user_id, i[f]).order("#{self.table_name}.#{f} DESC").limit(1) }
  scope :next,     lambda { |i, f| where("#{self.table_name}.user_id = ? AND #{self.table_name}.#{f} > ?", i.user_id, i[f]).order("#{self.table_name}.#{f} ASC").limit(1) }
  
  scope :per_localita, order('clienti.provincia, clienti.comune, clienti.id')
  
  
  def self.grouped_by_provincia_and_comune
    clienti = scoped
    clienti = clienti.group_by(&:provincia).each do |k, v|
      
    end  
    clienti
  end
  
  def self.con_appunti(relation)
    ids = relation.pluck(:cliente_id).uniq
    Cliente.where('clienti.id in (?)', ids)
  end
  
  #after_initialize :set_indirizzi
  
  before_save :set_titolo
  
  TIPI_CLIENTI.each do |tipo|
    scope "#{tipo.split.join.underscore}", where("clienti.cliente_tipo = ?", tipo)
    
    define_method "#{tipo.split.join.underscore}?" do
      self.cliente_tipo == tipo
    end
  end
  
  class << self
    # TIPI_CLIENTI.each do |tc|
    #   define_method "#{tc.split.join.underscore}" do
    #     cliente_tipo
    #   end
    # end
  end  
  
  def to_s
    "##{id} - #{titolo} #{frazione} #{comune} (#{provincia})"
  end
  
  def nel_baule
    nel_baule = false
    self.visite.each do |v|
      if v.nel_baule?
        nel_baule = v.id
      end
    end 
    nel_baule
  end
  
  def mie_adozioni_grouped
    adozioni = self.mie_adozioni.
                    includes(:libro, :classe, :materia).
                    order('classi.classe, adozioni.materia_id, classi.sezione, libri.id').
                    group_by {|c| { :classe => c.classe.classe, :materia => c.materia.materia, :titolo => c.libro.titolo, :settore => c.libro.settore }}
  end
  
  def classi_grouped
    classi = self.classi.
                    order('classi.classe, classi.sezione').
                    group_by(&:classe)
  end
  
  def classi_adozioni_grouped
    classi = self.classi.includes(:adozioni).order("classi.classe, classi.sezione").all.group_by(&:classe)
  end
    
  def self.ricalcola_properties

    Cliente.all.each do |c|
      prop = {}
      if c.mie_adozioni.size > 0
        prop = prop.merge(sezioni_adottate: c.mie_adozioni.size )
      end
      if c.righe.sum(:quantita) > 0
        prop = prop.merge(copie_vendute:  c.righe.sum(:quantita) )
      end
      if c.appunti.in_corso.size > 0
        prop = prop.merge(appunti_in_corso:  c.appunti.in_corso.size )
      end
      if c.righe.scarico.di_questa_propaganda.da_consegnare.sum(:quantita) > 0
        prop = prop.merge(copie_da_consegnare:  c.righe.scarico.di_questa_propaganda.da_consegnare.sum(:quantita) )
      end
      
      c.properties = prop
      c.save   
    end
  end  
  
  %w[sezioni_adottate copie_vendute appunti_in_corso].each do |key|
    # attr_accessible key
    scope "has_#{key}", where("(properties -> '#{key}')::int > 0")

    define_method(key) do
      properties && properties[key]
    end
  end
  
  def set_indirizzi
    # self.indirizzi.build(tipo: 'Indirizzo fattura') unless self.indirizzo.present?
    # self.indirizzi.build(tipo: 'Indirizzo spedizione') unless self.indirizzo_spedizione.present?
  end

  def self.filtra(params)
    
    # user = User.find(params[:user_id])
    
    clienti = scoped
    clienti = clienti.where("clienti.titolo ilike ?  or clienti.comune ilike ? or clienti.frazione ilike ?", 
                          "%#{params[:search]}%", "%#{params[:search]}%", "#{params[:search]}%") if params[:search].present?
    
    clienti = clienti.where("clienti.provincia = ?", params[:provincia])  if params[:provincia].present?
    clienti = clienti.where("clienti.comune = ?",    params[:comune])     if params[:comune].present?

    clienti = clienti.scuole     if params[:tipo].present? && params[:tipo] == 'scuole'
    clienti = clienti.primarie   if params[:tipo].present? && params[:tipo] == "primarie"
    clienti = clienti.cartolerie if params[:tipo].present? && params[:tipo] == "cartolerie"
    clienti = clienti.direzioni  if params[:tipo].present? && params[:tipo] == "direzioni"
    clienti = clienti.altri      if params[:tipo].present? && params[:tipo] == "altri"

    clienti = clienti.con_appunti(Appunto.in_corso)   if params[:status].present? && params[:status] == 'in_corso'
    clienti = clienti.con_appunti(Appunto.completo)   if params[:status].present? && params[:status] == "completati"
    clienti = clienti.con_appunti(Appunto.da_fare)    if params[:status].present? && params[:status] == "da_fare"
    clienti = clienti.con_appunti(Appunto.in_sospeso) if params[:status].present? && params[:status] == "in_sospeso"
    clienti
  end
  
  # geocoded_by :full_street_address
  
  # after_validation :geocode, 
  #                        :if => lambda{ |obj| obj.indirizzo_changed? || obj.cap_changed? || obj.citta_changed? || obj.cap_changed? || obj.indirizzable.citta_changed? }
  
  def full_street_address
    # [self.indirizzo, self.cap, self.frazione, self.comune, self.provincia].join(', ')
  end
  
  acts_as_gmappable :check_process => true, :checker => "gmaps"
  
  def gmaps4rails_address
    "#{self.indirizzo}, #{self.frazione}, #{self.comune}, #{self.provincia}"
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
  
  
  def nel_baule?
    !self.visite.nel_baule.empty?
  end

  after_save :load_into_soulmate
  
  def self.search_mate(term, id_user)
    matches = Soulmate::Matcher.new("#{id_user}_cliente").matches_for_term(term)
  end
  
  def load_into_soulmate
    loader = Soulmate::Loader.new("#{user_id}_cliente")
    loader.add({
                  "term" => "#{titolo} #{comune} #{frazione} #{provincia} #{ragione_sociale}".squish, 
                  "id" => id, 
                  "data" => { 
                    "url" => "clienti/#{slug}",
                    "titolo" => titolo, 
                    "citta"  => "#{comune} #{frazione} #{provincia}".squish
                  }
                })
  end



  private
  
    def set_titolo
      n = self.titolo.squish.split(' ')
      suff = Cliente::ABBR_TIPI[Cliente::TIPI_CLIENTI.index(self.cliente_tipo)]
      
      unless n[0] == suff
        self.titolo = (suff + " " + self.titolo).squish
      end
    end

end


# == Schema Information
#
# Table name: clienti
#
#  id              :integer         not null, primary key
#  titolo          :string(255)
#  cliente_tipo    :string(255)
#  nome            :string(255)
#  cognome         :string(255)
#  ragione_sociale :string(255)
#  abbr            :string(255)
#  codice_fiscale  :string(255)
#  partita_iva     :string(255)
#  indirizzo       :string(255)
#  cap             :string(255)
#  frazione        :string(255)
#  comune          :string(255)
#  provincia       :string(255)
#  telefono        :string(255)
#  telefono_2      :string(255)
#  fax             :string(255)
#  cellulare       :string(255)
#  email           :string(255)
#  url             :string(255)
#  gmaps           :boolean
#  longitude       :float
#  latitude        :float
#  user_id         :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  ancestry        :string(255)
#  slug            :string(255)
#

