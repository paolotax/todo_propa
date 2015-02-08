class Riga < ActiveRecord::Base
  
  belongs_to :appunto, touch: true
  
  belongs_to :libro
  belongs_to :fattura
  
  after_initialize :init
  
  after_save    :ricalcola_after_update
  after_destroy :ricalcola_after_destroy

  delegate :titolo, :prezzo_copertina, :prezzo_consigliato, :iva, :to => :libro

  has_and_belongs_to_many :documenti

  before_validation do
    self.uuid = UUIDTools::UUID.random_create.to_s if uuid.nil?
  end

  scope :scarico,       joins(:appunto).where("appunti.deleted_at IS NULL")
  scope :carico,        where("righe.appunto_id is NULL")

  scope :documentato,     includes(:documenti).where("documenti.id IS NOT NULL")
  scope :non_documentato, includes(:documenti).where("documenti.id IS NULL")

  scope :nulle,           carico.non_documentato

  scope :not_deleted,   joins(:appunto).where("appunti.deleted_at IS NULL")
  scope :deleted,       joins(:appunto).where("appunti.deleted_at IS NOT NULL")
    
  scope :per_libro_id,  order("righe.libro_id")
  scope :per_titolo,    joins(:libro).order("libri.titolo asc")
  scope :per_cm,        joins(:libro).order("libri.cm asc")
  scope :per_id,        order(:id)
  

  scope :da_fare,       scarico.where("appunti.stato = ''")
  scope :preparato,     scarico.where("appunti.stato = 'S'")
  
  
  scope :da_consegnare, scarico.where("righe.consegnato = false")
  scope :da_pagare,     scarico.where("righe.pagato     = false")
  
  scope :da_fatturare,  scarico.where("righe.fattura_id is null or righe.fattura_id = 0")
  scope :fatturata,     scarico.where("righe.fattura_id is not null or righe.fattura_id != 0")
  
  scope :consegnata,    scarico.where("appunti.stato in ('X', 'P')")
  scope :pagata,        where("righe.pagato = true")
  
  scope :di_questa_propaganda,  joins(:appunto).where("appunti.created_at > ?", Date.new(2014,1,1))  
  scope :di_quest_anno,         joins(:fattura).where("extract(year from fatture.data) = ?", 2014)
  scope :dell_anno, lambda { |a| joins(appunto: [:cliente]).where("extract(year from appunti.created_at) = ?", a)}
  
  scope :open_vendita, -> { scarico.with_state(:open, :ordinata)}
  scope :open_carico,  -> { carico.with_state(:open, :ordinata) }
  scope :open_fattura, -> { carico.with_state(:open, :ordinata, :caricata) }
  

  state_machine :initial => :open do

    event :prepara do
      transition :open => :pronta
    end

    event :consegna do
      transition [:open, :pronta] => :consegnata
    end

    event :registra do
      transition [:open, :consegnata] => :registrata
    end

    event :annulla_registra do

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
    end
  end

  
  def last_ordine?
    true if documenti.last.try(:documento_causale) == "Ordine"
  end

  
  def last_carico?
    true if documenti.last.try(:documento_causale) == "Bolla di carico"
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


  def anno
    if appunto
      appunto.created_at.to_date.year
    else
      fattura.data.year
    end
  end

  
  def da_registrare?
    self.fattura_id.nil?
  end


  def riga_abbreviata
    self.libro.sigla + " " + self.quantita.to_s
  end


  def documento
    self.appunto || self.fattura
  end

  def cliente
   self.appunto.cliente || self.fattura.cliente
  end
  
  
  def prezzo
    if sconto == 0.0
      prezzo_unitario
    else
      prezzo_copertina
    end
  end
  
  
  def remove_fattura=(value)
    if value == "true"
      self.fattura_id = nil
      self.save
    end
  end
 

  def remove_documento=(value)
    
    if value == "true"
      documento = self.documenti.last
      if documento
        documento.righe = documento.righe - [self]
        self.elimina_documento
      end     
    end
  end

  
  def prezzo=(text)
    self.prezzo_unitario = text
  end
  
  
  def importo
    sconto.nil? ? sc = 0.0 : sc = sconto
    prezzo_unitario * quantita * (100.0 - sc) / 100
  end

  
  private
  
    def init
      self.consegnato ||= false
      self.pagato     ||= false
      self.sconto     ||= 0.0           #will set the default value only if it's nil
    end  
  
    def ricalcola_after_update      
      
      unless appunto.nil? # non ricalcola ordine
        logger.debug "total_recalc"
        return true unless quantita_changed? || prezzo_unitario_changed? || fattura_id_changed? || sconto_changed? || appunto_id_changed?
        appunto.update_attributes(:totale_copie => appunto.righe.sum(&:quantita), :totale_importo => appunto.righe.sum(&:importo))
        return true
      else
        return true unless quantita_changed? || prezzo_unitario_changed? || sconto_changed? || documenti.empty?  
        documenti.each do |documento|
          documento.update_attributes(:totale_copie => documento.righe.sum(&:quantita), :totale_importo => documento.righe.sum(&:importo))
        end 
        return true        
      end
    end

    def ricalcola_after_destroy
      unless appunto.nil?
        logger.debug "riga destroy"
        appunto.update_attributes(:totale_copie => appunto.righe.sum(&:quantita), :totale_importo => appunto.righe.sum(&:importo))
        return true
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
#  state           :string(255)
#  position        :integer
#

