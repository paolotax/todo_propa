class Cliente < ActiveRecord::Base


  def self.correggi_anno_classi

    Cliente.includes(:classi).scuola_primaria.each do |cliente|

      unless cliente.da_scorrere?
        cliente.classi.update_all anno: Time.now.year
      end
    end
  end


  def self.spara
    Cliente.direzioni.per_localita.each do |c|
      puts c.titolo
      c.children.each do |s|
        puts "- #{s.titolo}"
      end
    end
  end
  
  TIPI_CLIENTI = ['Scuola Primaria', 'Istituto Comprensivo', 'Direzione Didattica', 'Cartolibreria', 'Persona Fisica', 'Ditta', 'Comune']
  ABBR_TIPI    = ['E', 'IC', 'D', 'C', '', '', 'Com']
  
  extend FriendlyId
  friendly_id :titolo, use: [:slugged, :history]
  
  has_ancestry

  belongs_to :user

  has_many :appunti, dependent: :destroy
  has_many :fatture, dependent: :destroy
  has_many :visite,  dependent: :destroy
  has_many :indirizzi, :as => :indirizzable, :dependent => :destroy

  has_many :classi,      :dependent => :destroy
  has_many :adozioni,     :through => :classi, :include => :libro
  has_many :mie_adozioni, :through => :classi, :source => :adozioni, :include => :libro, :conditions => "libri.settore = 'Scolastico'"
  
  has_many :righe, through: :appunti

  has_one :propa2014

  accepts_nested_attributes_for :indirizzi,  :reject_if => lambda {|a| a[:comune].nil? || a[:provincia].nil?}, :allow_destroy => true  
  
  validates :titolo,  :presence => true,
                      :uniqueness => { :scope => :user_id, :message => "gia' utilizzato" }

  validates :comune,       :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  validates :cliente_tipo, :inclusion => {:in => TIPI_CLIENTI, :message => "non hai scelto il tipo cliente" }
  
  before_validation do
    self.uuid = UUIDTools::UUID.random_create.to_s if uuid.nil?
  end

  scope :select_provincia, select("clienti.provincia").uniq
  scope :select_citta,     select("clienti.comune").uniq
  
  scope :nel_baule,        joins(:visite).where("visite.baule = true")
  
  scope :con_vacanze_da_ritirare, where("(properties -> 'vacanze_da_ritirare')::int >= 9") 
  scope :con_vacanze_ritirate,    where("(properties -> 'vacanze_da_ritirare')::int < 9") 

  scope :con_adozioni_da_consegnare, where("(properties -> 'adozioni_da_consegnare' <> '0') or (properties -> 'adozioni_saggi' <> '0') or (properties -> 'adozioni_kit_no_saggio' <> '0')")
  
  scope :con_adozioni_consegnate,    where("properties -> 'adozioni_kit' <> '0'") 
  
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

  
  def crea_consegna(riga_ids = [])

    righe = Riga.find(riga_ids)

    if righe.size > 0

      appunti = righe.map(&:appunto).uniq
      # appunti = Appunto.find(appunti_ids)

      appunto = self.appunti.build
      appunto.save

      righe.each do |riga|
        riga.appunto = appunto
        riga.save
      end

      appunto.save

      appunti.each { |a| a.ricalcola}
    end    
  end

  def da_scorrere?
    anno = anno_scolastico
    if anno && anno < Time.now.year.to_s && Time.now > Date.new(Time.now.year, 6, 1)
      true
    else
      false
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
    !self.fatture.empty?
  end
  
  
  def has_sospeso?
    !self.appunti.select {|a| a.status == 'in_sospeso'  && !a.totale_importo.zero? }.empty?
  end

  
  def eliminato?
    !deleted_at.nil?
  end

  
  def to_s
    "##{id} - #{titolo} #{frazione} #{comune} (#{provincia})"
  end

  def nel_baule?
    !self.visite.select{ |v| v.nel_baule? == true}.empty?
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


  def localita
    if frazione.blank?
      comune
    else
      frazione
    end
  end 


  def anno_scolastico
    anno = classi.pluck("classi.anno").uniq[0]
    anno
  end 


  def next_visita
    visite.next
  end

  
  def visita
    visite.order(:start).last
  end


  def visita=(visita)
    if visita
    else
    end
  end

  
  def giro_fatto?
    scuola_primaria? && !visite.select{|v| v.scopo && v.scopo.include?("serie")}.empty? && !visite.select{|v| v.scopo && v.scopo.include?("ritiro")}.empty?
  end


  def da_ritirare?
    scuola_primaria? && !visite.select{|v| v.scopo && v.scopo.include?("serie")}.empty? && visite.select{|v| v.scopo && v.scopo.include?("ritiro")}.empty?
  end


  def visite_scopo
    visite.all.select {|a| a.data != nil}.sort_by(&:data).map {|a| a.scopo.try(:split, ", ")}.reject {|a| a.nil?}.flatten.join(", ") 
  end

  
  def fatto?
    unless nel_baule
      self.visite.each do |v|
        if v.data > Date.new(2013, 4, 15)
          return true
        end
      end
    end
    false      
  end

  def last_giro
    visite.where("baule != true").order('start desc').first
  end

  def has_adozioni?
    self.scuola_primaria? && !self.mie_adozioni.empty?
  end

  def preparato?
    !appunti.select {|a| a.status == "preparato"}.empty?
  end

  # meglio questo delle query?
  def vacanze_da_ritirare
    if self.scuola_primaria?
      vacanze_fiuto    = self.classi.select { |c| c.libro_1 == 'vacanze_fiuto' }.size
      vacanze_castelli = self.classi.select { |c| c.libro_2 == 'vacanze_castelli' }.size
      vacanze_tutto    = self.classi.select { |c| c.libro_3 == 'vacanze_tutto' }.size      
      da_ritirare = vacanze_fiuto + vacanze_castelli + vacanze_tutto
    end
  end

  def adozioni_da_consegnare
    if self.scuola_primaria?
      adozioni_da_consegnare = self.mie_adozioni.select { |a| a.stato == 'da consegnare' }
    end  
  end
  
  def adozioni_saggi
    if self.scuola_primaria?
      adozioni_saggi = self.mie_adozioni.select { |a| a.stato == 'saggio' }
    end
  end
  
  def adozioni_kit
    if self.scuola_primaria?
      adozioni_kit = self.mie_adozioni.select { |a| a.stato == 'kit' }
    end
  end

  def adozioni_kit_no_saggio
    if self.scuola_primaria?
      adozioni_kit_no_saggio = self.mie_adozioni.select { |a| a.stato == 'saggio+guida' }
    end
  end

  def saggi_da_consegnare
    if self.scuola_primaria?
      saggi_da_consegnare = self.mie_adozioni.select { |a| a.kit_1 != 'consegnato' }
    end
  end
  
  def kit_da_consegnare
    if self.scuola_primaria?
      kit_da_consegnare = self.mie_adozioni.select { |a| a.kit_2 != 'consegnato' }
    end
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
  
  def max_classi
    max_classi = 0
    temp = classi_adozioni_grouped
    temp.each do |k, v|
      if v.size > max_classi
        max_classi = v.size
      end
    end
    max_classi
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
    if appunti.preparato.size > 0
      prop = prop.merge(appunti_pronti:  appunti.preparato.size )
    end
    if appunti.in_sospeso.size > 0
      prop = prop.merge(appunti_in_sospeso:  appunti.in_sospeso.size )
      prop = prop.merge(importo_in_sospeso:  appunti.in_sospeso.sum(&:totale_importo) )
    end
   
    if vacanze_da_ritirare
      prop = prop.merge(vacanze_da_ritirare: vacanze_da_ritirare)
    end

    if adozioni_saggi && adozioni_saggi.size > 0
      prop = prop.merge(adozioni_saggi: adozioni_saggi.size)
    end

    if adozioni_kit && adozioni_kit.size > 0
      prop = prop.merge(adozioni_kit: adozioni_kit.size)
    end

    if adozioni_da_consegnare && adozioni_da_consegnare.size > 0
      prop = prop.merge(adozioni_da_consegnare: adozioni_da_consegnare.size)
    end

    if adozioni_kit_no_saggio && adozioni_kit_no_saggio.size > 0
      prop = prop.merge(adozioni_kit_no_saggio: adozioni_kit_no_saggio.size)
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
    clienti = clienti.con_appunti(Appunto.preparato)  if params[:status].present? && params[:status] == "preparati"
    
    clienti = clienti.nel_baule if params[:nel_baule].present? && params[:nel_baule] == "true"

    clienti = clienti.con_vacanze_da_ritirare if params[:vacanze_da_ritirare].present? && params[:vacanze_da_ritirare] == "true"
    clienti = clienti.con_vacanze_ritirate if params[:vacanze_da_ritirare].present? && params[:vacanze_da_ritirare] == "false"

    clienti = clienti.con_adozioni_da_consegnare if params[:adozioni_da_consegnare].present? && params[:adozioni_da_consegnare] == "true"
    clienti = clienti.con_adozioni_consegnate if params[:adozioni_da_consegnare].present? && params[:adozioni_da_consegnare] == "false"

    clienti
  end

  def self.ordina(params)
    clienti = scoped
    unless params[:ordine].present?
      clienti = clienti.order("clienti.id")
    else

      clienti = clienti.order('clienti.provincia, clienti.comune, clienti.id') if params[:ordine] == "comune"

      clienti = clienti.order('clienti.titolo') if params[:ordine] == "nome"
      
    end 
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

