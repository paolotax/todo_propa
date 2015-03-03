class Riga < ActiveRecord::Base
  
  belongs_to :appunto, touch: true
  
  belongs_to :libro, touch: true

  belongs_to :fattura
  
  after_initialize :init
    
  before_save :set_importo

  after_save     :ricalcola_after_commit
  before_destroy :ricalcola_before_destroy

  
  delegate :titolo, :settore, :prezzo_copertina, :prezzo_consigliato, :iva, :to => :libro


  has_many :documenti_righe
  has_many :documenti, through: :documenti_righe


  before_validation do
    self.uuid = UUIDTools::UUID.random_create.to_s if uuid.nil?
  end


  scope :scarico,       joins(:appunto).where("appunti.deleted_at IS NULL")
  scope :carico,        where("righe.appunto_id is NULL")

  scope :not_deleted,   joins(:appunto).where("appunti.deleted_at IS NULL")
  scope :deleted,       joins(:appunto).where("appunti.deleted_at IS NOT NULL")
    
  scope :per_libro_id,  order("righe.libro_id")
  scope :per_titolo,    joins(:libro).order("libri.titolo asc")
  scope :per_cm,        joins(:libro).order("libri.cm asc")
  scope :per_id,        order(:id)
  scope :per_position,  order(:position)



  scope :documentato,     includes(:documenti).where("documenti.id IS NOT NULL")  
  scope :non_documentato, includes(:documenti).where("documenti.id IS NULL")

  scope :nulle,           carico.non_documentato
  scope :da_fare,       scarico.where("appunti.stato = ''")
  scope :preparato,     scarico.where("appunti.stato = 'S'")
  
  scope :da_pagare,     scarico.where("righe.pagato     = false")

  
  scope :da_fatturare,  scarico.where("righe.fattura_id is null or righe.fattura_id = 0")
  scope :fatturata,     scarico.where("righe.fattura_id is not null or righe.fattura_id != 0")
  
  scope :consegnata,    scarico.where("appunti.stato in ('X', 'P')")
  scope :pagata,        where("righe.pagato = true")
  
  scope :di_questa_propaganda,  joins(:appunto).where("appunti.created_at > ?", Date.new(2014,1,1))  
  
  scope :di_quest_anno,         joins(:fattura).where("extract(year from fatture.data) = ?", 2014)
  


  scope :da_consegnare, -> { scarico.with_state(:open, :pronta) } # scarico.where("righe.consegnato = false")

  scope :dell_anno, lambda { |anno | where("extract(year from righe.consegnata_il) = ?", anno) }
  
  scope :del_libro, lambda { |libro| where("righe.libro_id = ?", libro.id) }

  scope :open_vendita, -> { scarico.with_state(:open, :pronta, :consegnata)}
  
  scope :open_carico,  -> { carico.with_state(:open, :ordinata) }
  scope :open_fattura, -> { carico.with_state(:open, :ordinata, :caricata) }
  
  def self.non_documentato
    scoped.all.select{ |r| r.documenti.empty?}
  end


  




  state_machine :initial => :open do

    event :prepara do
      transition :open => :pronta
    end

    event :consegna do
      transition [:open, :pronta] => :consegnata
    end

    # event :annulla_consegna do
    #   transition :consegnata => :open
    # end

    event :registra do
      transition [:open, :pronta, :consegnata] => :registrata,    :if => :last_fattura?
      transition [:open, :pronta, :consegnata] => :corrispettivi, :if => :last_buono?
    end
    
    event :annulla_registra do
      transition [:registrata, :corrispettivi]=> :consegnata
    end
    
    event :ordina do
      transition :open => :ordinata
    end

    event :carica do
      transition [:open, :ordinata] => :caricata
    end

    event :registra_carico do
      transition [:open, :ordinata, :caricata] => :fatturata
    end

    event :elimina_documento do
      transition :ordinata => :open
      transition :caricata => :ordinata,  :if => :last_ordine?
      transition :fatturata => :caricata, :if => :last_carico?
      transition :fatturata => :ordinata, :if => :last_ordine?
      # transition :consegnata => :open,    :if => :last_consegna?
    end
  end

  
  def last_ordine?
    true if documenti.last.try(:documento_causale) == "Ordine"
  end

  
  def last_carico?
    true if documenti.last.try(:documento_causale) == "Bolla di carico"
  end

  def last_buono?
    true if documenti.last.try(:documento_causale) == "Buono di consegna"
  end

  
  def last_fattura?
    true if documenti.last.try(:documento_causale) == "Fattura"
  end  


  def last_consegna?
    true if documenti.empty?
  end

  
  def self.stats
    tutte = Riga.all.size
    carichi = Riga.carico.size
    scarichi = Riga.scarico.size
    deleted = Riga.deleted.size
    nulle = Riga.nulle.size   
    "#{tutte}=#{carichi}+#{scarichi}+#{nulle}+#{deleted} ? #{tutte-carichi-scarichi-nulle-deleted}"
  end


  def state_documento

    if state == "ordinata"
      return self.documenti.ordine.last
    elsif state == "caricata"
      return self.documenti.bolla_di_carico.last
    else
      return nil
    end

  end


  def previous_documento(documento)
    documenti.previous(documento.id).try(:first) || nil
  end




  def orfana?
    appunto_id.nil? && documenti.empty?
  end


  def eliminata?
    appunto.try(:deleted?) || false
  end


  def carico?
    appunto_id.nil?
  end


  def scarico?
    !carico?
  end


  def cached_libro
    Libro.cached_find(libro_id)
  end

  
  def da_registrare?
    self.fattura_id.nil?
  end


  def riga_abbreviata
    self.libro.sigla + " " + self.quantita.to_s
  end






  def documento
    documenti.order("documenti.causale_id").last || self.appunto
  end

  
  def causale
    if documento.is_a? Appunto
      'Appunto'
    else
      documento.causale.causale
    end
  end


  def data
    if documento.is_a? Appunto
      documento.created_at.to_date
    elsif documento.is_a? Documento
      documento.data
    else
      Time.now.to_date
    end
  end
  
  
  def anno
    data.year
  end

  
  def cliente
    documento.cliente
  end
  
  
  def prezzo
    if sconto == 0.0
      prezzo_unitario
    else
      prezzo_copertina
    end
  end
  
    
  def prezzo=(text)
    self.prezzo_unitario = text
  end
  
  
  def check_all_states

    last_documento = self.documenti.order(:causale_id).last
      
      
    if last_documento

      self.pagata_il = last_documento.payed_at

      if last_documento.ordine?
        self.state = "ordinata"
      elsif last_documento.bolla_di_carico?
        self.state = "caricata"
        self.consegnata_il = last_documento.data
      elsif last_documento.fattura_acquisti?
        self.state = "fatturata"
        self.consegnata_il = last_documento.data
      elsif last_documento.buono_di_consegna?
        self.state = "corrispettivi"
        self.consegnata_il = last_documento.data
      elsif last_documento.fattura?
        self.state = "registrata"
        self.consegnata_il = last_documento.data
      end
      
    else

      self.state = "open"
      if self.appunto
        if self.appunto.stato == 'P'
          self.consegnata_il = self.appunto.created_at.to_date
          self.state = 'consegnata'
        elsif self.appunto.stato = 'X'
          self.state = 'consegnata'
          self.consegnata_il = self.appunto.created_at.to_date
          self.pagata_il = self.appunto.created_at.to_date
        end
      end

    end
    
    self.save

  end
    
  private
  
    
    def init
      self.consegnato ||= false
      self.pagato     ||= false
      self.quantita   ||= 0
      self.sconto     ||= 0.0
      self.importo    ||= 0.0           #will set the default value only if it's nil
    end  


    def set_importo
      self.importo = (prezzo_unitario * quantita * (100.0 - sconto) / 100.0)
    end


    def ricalcola_after_commit           
      return true  unless quantita_changed? || importo_changed?
      if appunto
        Appunto.update_counters appunto.id,
          totale_copie: quantita - (quantita_was || 0.0),
          totale_importo: importo - importo_was      
      end
      documenti.each do |documento|
        Documento.update_counters documento.id,
          totale_copie:   quantita - (quantita_was || 0.0),
          totale_importo: importo  - importo_was     
      end
      return true        
    end

    
    def ricalcola_before_destroy
      unless appunto.nil?
        Appunto.update_counters appunto.id,
          totale_copie: - quantita_was,
          totale_importo: - importo_was
      end
      documenti.each do |documento|
        Documento.update_counters documento.id,
          totale_copie:   - quantita_was,
          totale_importo: - importo_was     
      end
    end

end


# == Schema Information
#
# Table name: righe
#
#  id              :integer         not null, primary key
#  libro_id        :integer
#  quantita        :integer
#  prezzo_unitario :decimal(9, 3)
#  sconto          :decimal(5, 2)   default(0.0)
#  consegnato      :boolean
#  pagato          :boolean
#  appunto_id      :integer
#  fattura_id      :integer
#  magazzino_id    :integer
#  causale_id      :integer
#  movimento       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  uuid            :string
#  importo         :decimal(9, 2)   default(0.0)
#  state           :string(255)
#  position        :integer
#  pagata_il       :date
#  consegnata_il   :date
#

