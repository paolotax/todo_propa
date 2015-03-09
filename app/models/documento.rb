class Documento < ActiveRecord::Base

  
  TIPO_PAGAMENTO = ["Contanti", "Assegno", "Bonifico Bancario", "Bollettino Postale"]
  
  
  extend FriendlyId
  friendly_id :doc_slug, use: [:slugged, :history]

  belongs_to :user
  belongs_to :causale
  belongs_to :cliente

  has_many :documenti_righe
  has_many :righe, through: :documenti_righe
  
  has_many :documenti, through: :righe, uniq: true    
  has_many :appunti, through: :righe, uniq: true, order: "appunti.id"
    
  accepts_nested_attributes_for :righe, reject_if: lambda { |a| (a[:quantita].blank? || a[:quantita].to_i.zero? || a[:libro_id].blank?)}, allow_destroy: true


  validates :cliente_id, :causale_id, :data, :numero, presence: true, if: :active?
  
  delegate :titolo,  to: :cliente
  delegate :causale, :carico?, :scarico?, to: :causale, prefix: :documento

  scope :scarico, joins(:causale).where("causali.tipo = 'scarico'")
  scope :carico,  joins(:causale).where("causali.tipo = 'carico'")

  scope :per_numero,     order('documenti.data desc, documenti.numero desc')
  scope :per_numero_asc, order('documenti.data, documenti.numero') 


  scope :dell_anno,      lambda { |a| where("extract(year from documenti.data) = ?", a) }

  scope :previous, lambda { |d| order("documenti.id desc").where("documenti.id < ?", d).limit(1) }


  Causale.all.each do |causale|
    scope "#{causale.causale.downcase.split.join('_')}", where("causale_id = ?", causale.id)
    
    define_method "#{causale.causale.downcase.split.join('_')}?" do
      self.causale == causale
    end
  end
  
  
  TIPO_PAGAMENTO.each do |tipo|
    scope "#{tipo.downcase.split.join('_')}", where("condizioni_pagamento = ?", tipo)
    
    define_method "#{tipo.downcase.split.join('_')}?" do
      self.condizioni_pagamento == tipo
    end
  end



  around_destroy :elimina_registrazione
  def elimina_registrazione
    righe_ids = self.righe.map(&:id)
    
    yield

    righe_to_update = Riga.includes(:documenti).find righe_ids
    righe_to_update.each { |r| r.elimina_documento }
  end
  

  after_save :registra
  def registra
    righe.all.each do |r|
      if documento_scarico? 
        #raise r.inspect
        r.registra
      elsif documento_causale == "Ordine"
        r.ordina
      elsif documento_causale == "Bolla di carico"
        r.carica
      elsif documento_causale == "Fattura acquisti"
        r.registra_carico
      end
    end
  end



  def active?
    # serve per wicked gem
    # status == 'active'
    true
  end



  def calc_importo
    righe.map(&:importo).sum
  end

  def calc_copie
    righe.map(&:quantita).sum
  end

  def calc_importo_appunti
    appunti.map(&:totale_importo).sum
  end

  def differenza_importo
    (calc_importo - totale_importo).to_s
  end

  def differenza_copie
    (calc_copie - totale_copie).to_s
  end

  def differenza_importo_appunti
    (calc_importo_appunti - totale_importo).to_s
  end

  def importo_errato?
    !(calc_importo - totale_importo).between?(-0.01, 0.01)
  end

  def copie_errate?
    calc_copie != totale_copie
  end

  def importo_appunti_errato?
    !(calc_importo_appunti - totale_importo).between?(-0.01, 0.01)
  end


  def imponibile
    self.totale_importo - self.totale_iva
  end


  def pagata?
    !self.payed_at.nil?
  end

  
  def coerente?
    true
    unless appunti.empty?
      appunti.each do |a|
        return false if a.stato == 'X' && pagata? != true
        return false if a.stato == "P" && pagata? != false
        return false if a.stato.blank? && pagata? != false
      end
    else
      true
    end
  end


  def previous_documenti
    righe.includes(:documenti).map(&:documenti).flatten.uniq.select{|d| d.causale_id < self.causale_id}
  end

  
  def next_documenti
    righe.includes(:documenti).map(&:documenti).flatten.uniq.select{|d| d.causale_id > self.causale_id}
  end

  


  


  
  def get_new_id(user)
    last_id = Fattura.where("user_id = ? and data > ? and causale_id = ?", user.id, Time.now.beginning_of_year, self.causale_id).order('numero desc').limit(1)
    if last_id.empty?
      return 1
    else
      return last_id[0][:numero] + 1    
    end
  end
  
  



  def anno
    data.year || Date.today.year
  end


  def doc_slug
    
    unless causale.nil?
      "#{documento_causale}-#{anno}-#{numero}"
    end
  
  end 


  def leggi
  end


  def leggi=(leggi)
    new_righe = leggi.lines.to_a
    for r in leggi.lines do
      riga = r.squish.split
      if /\d{5}[A-Z]/.match riga.first
        libro = Libro.find_or_create_by_cm( cm: riga.first, titolo: riga[1..-2].join(" "), prezzo_consigliato: 0, prezzo_copertina: 0 )
        new_riga = self.righe.build( libro: libro, quantita:  riga.last, prezzo_unitario: libro.prezzo_copertina )
        new_righe.delete(r)
      end
    end
  end


  def importa_file=(file)
    
    return if file.nil?
    spreadsheet = open_spreadsheet(file)

    if spreadsheet.is_a? Array
      # uso smarter_csv
      spreadsheet.each do |row|
        libro = Libro.find_or_create_by_cm( cm: row[:codice], titolo: row[:descrizione], prezzo_consigliato: 0, prezzo_copertina: row[:prezzo], ean: row[:ean], editore_id: 29 )
        
        self.righe.build( libro: libro, quantita:  row[:qta], prezzo_unitario: libro.prezzo_copertina )
      end  

    else
      # uso roo per altri tipi di file
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]        
        libro = Libro.find_or_create_by_cm( cm: row["CODICE"], titolo: row["DESCRIZIONE"], prezzo_consigliato: 0, prezzo_copertina: row["PREZZO"], ean: row["EAN"], editore_id: 29 )
        
        self.righe.build( libro: libro, quantita:  row["QTA"], prezzo_unitario: libro.prezzo_copertina )
      end
    end
  end

  
  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then SmarterCSV.process(file.path, col_sep: ";")
      #Csv.new(file.path, csv_options: {encoding: Encoding::UTF_8})
    when ".xls" then Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end


  def self.filtra(params)
    documenti = scoped
    documenti = documenti.search(params[:search]) if params[:search].present?
    documenti = documenti.joins(:causale).where("causali.causale = ?", params[:causale]) if params[:causale].present?
    documenti = documenti.joins(:causale).where("causali.tipo = ?", params[:tipo_causale]) if params[:tipo_causale].present?
    documenti = documenti.where("extract(year from data) = ? ", params[:anno] ) if params[:anno].present?
    documenti = documenti.where("condizioni_pagamento = ?", params[:pagamento]) if params[:pagamento].present?
    documenti = documenti.where("pagata = ?", params[:pagata]) if params[:pagata].present?    
    documenti
  end


  def self.search(search)
    if search
      documenti = scoped
      documenti = documenti.joins(:cliente).where('clienti.titolo ilike ? or clienti.comune ilike ? or clienti.frazione ilike ? or documenti.slug ilike ?', 
                    "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else        
      scoped
    end
  end


  def self.next_numeri(user, anno)
    numeri = Documento.where("user_id = ? and extract(year from data) = ?", user.id, anno).select("causale_id, max(numero) as numero").group("causale_id")
    
    Causale.all.map do |c|
      [
        c.causale,
        "#{c.id},#{(numeri.select{|a| a.causale_id == c.id}.first.try(:numero) || 0) + 1}"
      ]
    end
  end


end


# == Schema Information
#
# Table name: documenti
#
#  id                   :integer         not null, primary key
#  numero               :integer
#  data                 :date
#  note                 :text
#  cliente_id           :integer
#  causale_id           :integer
#  user_id              :integer
#  condizioni_pagamento :string(255)
#  totale_copie         :integer         default(0)
#  totale_importo       :decimal(9, 2)   default(0.0)
#  totale_iva           :decimal(9, 2)   default(0.0)
#  spese                :decimal(9, 2)   default(0.0)
#  state                :string(255)
#  slug                 :string(255)
#  payed_at             :date
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

