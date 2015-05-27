class Riga < ActiveRecord::Base
  
  belongs_to :appunto, touch: true, counter_cache: true
  
  # counter_culture :appunto, touch: true  
  # counter_culture :appunto, delta_column: 'quantita', column_name: 'totale_copie'
  # counter_culture :appunto, delta_column: 'importo',  column_name: 'totale_importo', touch: true 


  has_many :documenti_righe
  has_many :documenti, through: :documenti_righe


  belongs_to :libro, touch: true

  
  after_initialize :init

  before_save :set_importo

  # uso after_save etc... perche counter_culture non funziona 
  after_save     :ricalcola_after_commit
  before_destroy :ricalcola_before_destroy
  # counter_culture :documenti, delta_column: 'quantita', column_name: 'totale_copie'
  # counter_culture :documenti, delta_column: 'importo',  column_name: 'totale_importo', touch: true 

  delegate :titolo, :settore, :prezzo_copertina, :prezzo_consigliato, :iva, :to => :libro

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


  
  scope :di_questa_propaganda,  joins(:appunto).where("appunti.created_at > ?", Date.new(2014,1,1))  
  
  scope :di_quest_anno,         joins(:fattura).where("extract(year from fatture.data) = ?", 2014)
  
  scope :dell_anno, lambda { |anno | where("extract(year from righe.consegnata_il) = ? or (extract(year from righe.created_at) = ? and extract(year from righe.consegnata_il) is null) ", anno, anno) }
  
  #scope :dell_anno, lambda { |anno | where("extract(year from righe.consegnata_il) = ?", anno) }
  
  scope :del_libro, lambda { |libro| where("righe.libro_id = ?", libro.id) }

  

  scope :open_carico,  -> { carico.with_state(:open, :ordinata) }
  scope :open_fattura, -> { carico.with_state(:open, :ordinata, :caricata) }
    
  scope :preparate,     -> { scarico.with_state(:pronta) }

  scope :da_consegnare, -> { scarico.with_state(:open) }
  scope :da_pagare,     -> { scarico.with_state(:consegnata) }
  scope :da_registrare, -> { scarico.with_state(:da_registrare) }


  # scope :da_consegnare, -> { scarico.with_state(:open, :pronta, :pagata, :registrata, :da_consegnare) }
  # scope :da_pagare,     -> { scarico.with_state(:open, :pronta, :consegnata, :registrata, :da_pagare) }
  scope :non_completa, -> { scarico.with_state(:open, :pronta, :pagata, :consegnata, :da_registrare) }


  state_machine :initial => :open do

    event :prepara do
      transition :open => :pronta
    end

    event :annulla_prepara do
      transition :pronta => :open
    end
    
    event :consegna do
      transition [:open, :pronta] => :consegnata
      transition :registrata      => :da_pagare
      transition :pagata          => :da_registrare
      transition :da_consegnare   => :fattura,       if: :last_fattura?
      transition :da_consegnare   => :corrispettivi, if: :last_buono?
    end

    event :annulla_consegna do
      transition :consegnata    => :open
      transition :da_registrare => :pagata
      transition :da_pagare     => :registrata
      transition :fattura       => :da_consegnare
      transition :corrispettivi => :da_consegnare
    end

    before_transition :on => :annulla_consegna do |riga, transition|
      riga.consegnata_il = nil
      riga.save
    end

    event :paga do
      transition [:open, :pronta] => :pagata
      transition :consegnata      => :da_registrare
      transition :registrata      => :da_consegnare

      transition :da_pagare       => :fattura,       if: :last_fattura?
      transition :da_pagare       => :corrispettivi, if: :last_buono?
    end
    
    event :annulla_pagamento do
      transition :pagata         => :open
      transition :da_registrare  => :consegnata
      transition :da_consegnare  => :registrata

      transition :fattura        => :da_pagare
      transition :corrispettivi  => :da_pagare
    end

    before_transition :on => :annulla_pagamento do |riga, transition|
      riga.pagata_il = nil
      riga.save
    end


    event :registra do
      transition [:open, :pronta] => :registrata
      transition :pagata          => :da_consegnare
      transition :consegnata      => :da_pagare
      transition :da_registrare   => :fattura,       if: :last_fattura? 
      transition :da_registrare   => :corrispettivi, if: :last_buono? 
    end
    
    
    event :annulla_registra do
      transition :registrata      => :open
      transition :da_consegnare   => :pagata
      transition :da_pagare       => :consegnata
      transition :fattura         => :da_registrare
      transition :corrispettivi   => :da_registrare
    end
    
    # carichi

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

  # questo serve per la scheda libro
  def data_da_raggruppare
    (consegnata_il || created_at).to_date
  end


  def consegna_in_data(data = Date.today)
    self.update_attributes(consegnata_il: data) if can_consegna?
    self.consegna
  end

  
  def paga_in_data(data = Date.today)
    self.update_attributes(pagata_il: data) if can_paga?
    self.paga
  end


  def registra_con_documento(documento)

  end


  def registra_con_causale(causale)

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


  def self.check_scarichi_state

    Riga.where("appunto_id is not null").each do |r|

      r.check_scarico_state

    end

  end

  def check_scarico_state

    state_was = state

    last_documento = self.documenti.order(:causale_id).last

    if last_documento

      if pagata_il.nil? && consegnata_il.nil?
        self.state = 'registrata'
      elsif !pagata_il.nil? && consegnata_il.nil?
        self.state = 'da_consegnare'
      elsif pagata_il.nil? && !consegnata_il.nil?
        self.state = 'da_pagare'
      else
        if last_documento.buono_di_consegna?          
          self.state = "corrispettivi"        
        else
          self.state = "fattura"
        end
      end

    else

      if pagata_il.nil? && consegnata_il.nil?
        self.state = 'open'
      elsif !pagata_il.nil? && consegnata_il.nil?
        self.state = 'pagata'
      elsif pagata_il.nil? && !consegnata_il.nil?
        self.state = 'consegnata'
      elsif !pagata_il.nil? && !consegnata_il.nil?
        self.state = 'da_registrare'
      end

    end

    # if state_was != state
    #   puts "#{id} - was #{state_was} is #{state}"
    # end

    save

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


  def scarico?
    !appunto_id.nil?
  end


  def carico?
    appunto_id.nil? && !orfana?
  end


  def orfana?
    appunto_id.nil? && documenti.empty?
  end


  def eliminata?
    appunto.try(:deleted?) || false
  end








  def cached_libro
    Libro.cached_find(libro_id)
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
  

  def self.filtra(params)
    righe = scoped
    #righe = righe.search(params[:search]) if params[:search].present?

    if params[:settore].present?
      righe = righe.joins(:libro).where('libri.settore = ?', params[:settore])
    end
    
    if params[:anno] != 'tutti'
      righe = righe.dell_anno(params[:anno])
    end    

    if params[:status]
      righe = righe.try(params[:status].split(" ").join("_"))
    end

    # if params[:comune]
    #   righe = righe.joins(appunto: :cliente).where('clienti.comune = ?', params[:comune])
    # end

    righe
  end
  

    
  private
  
    
    def init
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
#  appunto_id      :integer
#  magazzino_id    :integer
#  movimento       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  uuid            :string
#  importo         :decimal(9, 2)   default(0.0)
#  state           :string(255)
#  position        :integer
#  pagata_il       :date
#  consegnata_il   :date
#  documento_id    :integer
#

