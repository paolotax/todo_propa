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
  has_many :adozioni,     :through => :classi, :include => :libro
  has_many :mie_adozioni, :through => :classi, :source => :adozioni, :include => :libro, :conditions => "libri.settore = 'Scolastico'"
  
  has_many :righe, through: :appunti

  accepts_nested_attributes_for :indirizzi,  :reject_if => lambda {|a| a[:comune].nil? || a[:provincia].nil?}, :allow_destroy => true  
  
  validates :titolo,  :presence => true,
                      :uniqueness => { :scope => :user_id, :message => "gia' utilizzato" }

  validates :comune,       :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  validates :cliente_tipo, :inclusion => {:in => TIPI_CLIENTI, :message => "non hai scelto il tipo cliente" }
  
  scope :select_provincia, select("clienti.provincia").uniq
  scope :select_citta,     select("clienti.comune").uniq
  scope :nel_baule,        joins(:visite).where("visite.baule = true")
    
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
  
  # scope :con_adozioni, joins(:adozioni) & Adozione.scolastico  

  def localita
    if frazione.blank?
      comune
    else
      frazione
    end
  end      

  def self.grouped_by_provincia_and_comune
    clienti = scoped
    clienti = clienti.group_by(&:provincia)
    clienti
  end
  
  class << self
    ["adozioni", "appunti", "classi", "visite"].each do |objects|
      define_method "con_#{objects}" do |relation|
        ids = relation.pluck(:cliente_id)
        clienti = scoped
        clienti = clienti.where('clienti.id in (?)', ids)
        clienti
      end
  
      define_method "senza_#{objects}" do |relation|
        ids = relation.pluck(:cliente_id)
        clienti = scoped
        clienti = clienti.where('clienti.id not in (?)', ids)
        clienti
      end
  
    end
  end
  
  
  #after_initialize :set_indirizzi
  
  before_save :set_titolo
  
  TIPI_CLIENTI.each do |tipo|
    scope "#{tipo.split.join.underscore}", where("clienti.cliente_tipo = ?", tipo)
    
    define_method "#{tipo.split.join.underscore}?" do
      self.cliente_tipo == tipo
    end
  end
  
  def has_documenti?
    !self.appunti.empty? || !self.fatture.empty?
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
    nel_baule = nil
    self.visite.each do |v|
      if v.nel_baule?
        nel_baule = v
      end
    end 
    nel_baule
  end

  def nel_baule=(baule)
    if baule == true
      self.visite.build(baule: 't')
    else
      self.visite.nel_baule.each do |v|
        v.destroy
      end
    end
  end
  
  def fatto?
    unless nel_baule
      self.visite.each do |v|
        if v.start > Date.new(2013, 4, 15)
          return true
        end
      end
    end
    false      
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
      c.ricalcola_properties
    end
  end  


  # da rivedere non è certo ottimizzato
  def ricalcola_properties
    prop = {}
    if mie_adozioni.size > 0
      prop = prop.merge(sezioni_adottate: mie_adozioni.size )
    end
    if righe.scarico.da_consegnare.sum(:quantita) > 0
      prop = prop.merge(copie_da_consegnare:  righe.scarico.da_consegnare.sum(:quantita) )
    end
    if righe.sum(:quantita) > 0
      prop = prop.merge(copie_vendute:  righe.sum(:quantita) )
    end
    if appunti.da_fare.size > 0
      prop = prop.merge(appunti_da_fare:  appunti.da_fare.size )
    end
    if appunti.in_sospeso.size > 0
      prop = prop.merge(appunti_in_sospeso:  appunti.in_sospeso.size )
    end
   
    self.properties = prop
    save   
  end
  
  %w[sezioni_adottate copie_vendute copie_da_consegnare appunti_da_fare appunti_in_sospeso].each do |key|
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
    
    # %w(scuole primarie cartolerie direzioni altri).each do |tipos|
    #   clienti = clienti.tipos if params[:tipo].present? && params[:tipo] == tipos
    # end
      
    clienti = clienti.scuole     if params[:tipo].present? && params[:tipo] == 'scuole'
    clienti = clienti.primarie   if params[:tipo].present? && params[:tipo] == "primarie"
    clienti = clienti.cartolerie if params[:tipo].present? && params[:tipo] == "cartolerie"
    clienti = clienti.direzioni  if params[:tipo].present? && params[:tipo] == "direzioni"
    clienti = clienti.altri      if params[:tipo].present? && params[:tipo] == "altri"
    
    # devo mettere l'utente
    clienti = clienti.con_appunti(Appunto.in_corso)   if params[:status].present? && params[:status] == 'in_corso'
    clienti = clienti.con_appunti(Appunto.completo)   if params[:status].present? && params[:status] == "completati"
    clienti = clienti.con_appunti(Appunto.da_fare)    if params[:status].present? && params[:status] == "da_fare"
    clienti = clienti.con_appunti(Appunto.in_sospeso) if params[:status].present? && params[:status] == "in_sospeso"
    clienti
  end
  
  geocoded_by :full_street_address
  
  after_validation :geocode, 
        :if => lambda{ |obj| obj.indirizzo_changed? || obj.cap_changed? || obj.comune_changed? || obj.cap_changed? || obj.provincia_changed?}
  
  def full_street_address
    [self.indirizzo, self.cap, self.frazione, self.comune, self.provincia].join(', ')
  end
  
  acts_as_gmappable :validation => false, :check_process => true, :checker => "gmaps"
  
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

  def self.import(file, user_id)
    current_user = User.find(user_id)
    
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      cliente = find_by_id(row["id"]) || new

      #raise row.inspect

      cliente.attributes = row.to_hash #.slice(*accessible_attributes)
      cliente.user = current_user

      # raise cliente.inspect
      cliente.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Csv.new(file.path, nil, :ignore)
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |cliente|
        csv << cliente.attributes.values_at(*column_names)
      end
    end
  end
  
  private

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

