class Appunto < ActiveRecord::Base
  
  acts_as_taggable
  
  belongs_to :user
  belongs_to :cliente, touch: true
  
  STATUS       = ["da_fare", "in_sospeso", "preparato", "completato"]
  STATUS_CODES = ["", "P", "S", "X"]

  has_many :righe, :dependent => :destroy
  has_many :fatture, through: :righe, uniq: true
  
  has_many :visita_appunti, dependent: :destroy
  has_many :visite, :through => :visita_appunti
  
  has_many :events, class_name: "AppuntoEvent", dependent: :destroy

  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => true
  
  #  validates :user_id,  :presence => true
  validates :cliente_id,    :presence => true


  scope :recente,  order("appunti.id desc")
  scope :in_corso,   where("appunti.stato <> 'X'")
  
  scope :pop,        lambda { |id| where("appunti.cliente_id = ?", id) }
  
  scope :uniq_cliente_id, select(:cliente_id).uniq
  
  scope :recente_da_data, lambda { |data| includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?", data)  }
  scope :un_anno, lambda {  includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?",  1.year.ago)  }
  
  scope :di_questa_propaganda,  where("appunti.created_at > ?", Date.new(2013,5,1))
   
  
  include PgSearch
  pg_search_scope :search, against: [:destinatario, :note],
    using: {tsearch: {dictionary: "italian"}},
    associated_against: {cliente: [ :titolo, :comune, :frazione, :provincia ] },
    order_within_rank: "updated_at DESC"
  
  
  before_save :leggi

  after_update  :flush_cache
  after_destroy :flush_cache
  after_create  :flush_cache

  #after_commit  :flush_cache

  def flush_cache
    Rails.cache.delete([self, 'righe'])
    Rails.cache.delete([self, 'tag_list'])
  end

  def cached_righe
    Rails.cache.fetch([self, "righe"]) { righe.joins(:libro).order('libri.titolo').to_a }
  end
  
  def cached_tag_list
    Rails.cache.fetch([self, "tag_list"]) { self.tag_list }
  end
  
  def fattura
    self.fatture[0] unless self.fatture.empty?
  end
  
  STATUS.each_with_index do |status, index|
    scope "#{status}", where("appunti.stato = ?", STATUS_CODES[index])
    
    define_method "#{status}?" do
      self.stato == STATUS_CODES[index]
    end
  end
  
  def status
    STATUS[STATUS_CODES.index(stato)]
  end
  
  def status=(stato)
    self.stato = STATUS_CODES[STATUS.index(stato)]
  end  
  
  def da_consegnare?
    self.stato.blank?
  end
  
  def consegnato?
    in_sospeso? || completato?
  end
  
  def create_righe(scope)
    libri = scope.order(:titolo)
    libri.all.each do |l|
      
      prezzo = l.prezzo_copertina
      sconto = 20  
      if cliente.present? && !(["Cartolibreria", "Ditta"].include?  cliente.cliente_tipo)
        prezzo = l.prezzo_consigliato
        sconto = 0.0
      end

      righe.build(libro: l, prezzo_unitario: prezzo, sconto: sconto)
    end
  end
  
  def da_fatturare?
    self.has_righe? && self.fatture.empty? 
  end

  def fatturato?
    self.has_righe? && !self.fatture.empty? 
  end
  
  def has_righe?
    !self.righe.empty?
  end
  
  def has_recapiti?
   !self.telefono.blank? || !self.email.blank?
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
  
  def to_s
    "##{id} - #{destinatario} (#{cliente_nome})"
  end
  
  def to_param
    "#{id} #{destinatario} (#{cliente_nome})".parameterize
  end
  
  def cliente_nome
    self.cliente.titolo if cliente.present?
  end
  

  
  def self.filtra(params)
    appunti = scoped
    appunti = appunti.search(params[:search]) if params[:search].present?
    # appunti = appunti.where("appunti.destinatario ilike ? or clienti.titolo ilike ?  or clienti.comune ilike ? or clienti.frazione ilike ? or appunti.note ilike ?", 
    #            "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    appunti = appunti.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    appunti = appunti.where("clienti.comune = ?",    params[:comune])    if params[:comune].present?
    appunti = appunti.in_corso   if params[:status].present? && params[:status] == 'in_corso'
    appunti = appunti.completo   if params[:status].present? && params[:status] == "completati"
    appunti = appunti.preparato  if params[:status].present? && params[:status] == "preparati"
    appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    
    #appunti = appunti.pop(params[:cliente_id].to_i) if params[:cliente_id].present?
    appunti

  end
  
  def self.ordina(params)
    appunti = scoped
    unless params[:ordine].present?
      appunti = appunti.recente
    else
      appunti = appunti.joins(:cliente).order('clienti.titolo, appunti.created_at desc') if params[:ordine] == "cliente"

      appunti = appunti.joins(:cliente).order('clienti.provincia, clienti.comune, clienti.titolo, appunti.created_at desc') if params[:ordine] == "comune"

      appunti = appunti.order('cliente_id, appunti.created_at desc') if params[:ordine] == "cliente_id"
      
    end 
    appunti
  end

  # before_save :ricalcola
  # def ricalcola
  #   logger.debug "ricalcola"
  #   self.totale_copie   = righe.map(&:quantita).sum
  #   self.totale_importo = righe.map(&:importo).sum
  # end

  # after_save :check_importo
  # def check_importo
  #   logger.debug "check_importo"
  #   if righe.empty? && !self.totale_importo.zero? 
  #     self.totale_copie   = 0
  #     self.totale_importo = 0
  #     save
  #   end
  # end

  def self.check_status_fattura
    errors = []
    Appunto.all.each do |a|
      unless a.fattura.nil?
        if a.stato == 'X' && a.fattura.pagata != true
          errors << "errore X #{a.fattura.doc_id} appunto #{a.id} "
        end
        if a.stato == 'P' && a.fattura.pagata != false
          errors << "errore P #{a.fattura.doc_id} appunto #{a.id} "
        end
      end
    end
    puts errors.sort
  end
  
  after_save :update_righe_status
  after_save :load_into_soulmate

  after_commit :update_cliente_properties

  #after_save :update_cliente_properties
  #after_destroy :update_cliente_properties

  def self.search_mate(term, id_user)
    matches = Soulmate::Matcher.new("#{id_user}_appunto").matches_for_term(term)
  end
  
  def load_into_soulmate
    unless cliente.nil?
      loader = Soulmate::Loader.new("#{cliente.user_id}_appunto")
      loader.add({
                    "term" => " #{destinatario} #{cliente.titolo} #{cliente.comune} #{cliente.frazione} #{cliente.provincia} #{note.to_s} #{'tel_' + telefono unless telefono.blank?}".squish, 
                    "id" => id,
                    "score" => created_at.to_i, 
                    "data" => { 
                      "url" => "appunti/#{id}",
                      "destinatario" => destinatario,
                      "note" => "#{note}".squish,  
                      "titolo" => "#{cliente.titolo}", 
                      "citta" => "#{cliente.comune} #{cliente.frazione} #{cliente.provincia}".squish
                    }
                  })
    end
  end

  #  TDOO
  #  State Machine
  # 

  # STATES = %w[incompleto pronto consegnato spedito registrato pagato chiuso cancellato]
  # delegate :incompleto?, :pronto?, :consegnato?, :spedito?, 
  #          :registrato?, :pagato?, :chiuso?, :cancellato?, to: :current_state

  # class << self
  #   STATES.each do |state|
  #     define_method "#{state}" do
  #       joins(:events).merge AppuntoEvent.with_last_state(state)
  #     end
  #   end
  # end           

  # def current_state
  #   (events.last.try(:state) || STATES.first).inquiry
  # end

  # def prepara(valid_payment = true)
  #   if incompleto?
  #     events.create! state: "pronto" if valid_payment
  #   end
  # end
  
  # def consegna(valid_payment = true)
  #   if incompleto? || pronto?
  #     events.create! state: "consegnato" if valid_payment
  #   end
  # end

  private

    def leggi    
      # new_righe = self.note.lines.to_a
      # for r in self.note.lines do
      #   riga = r.squish.split
      #   if /\d{5}[A-Z]/.match riga.first
      #     libro = Libro.find_or_create_by_cm( cm: riga.first, titolo: riga[1..-2].join(" "), prezzo_consigliato: 0, prezzo_copertina: 0 )
      #     new_riga = self.righe.build( libro: libro, quantita:  riga.last, prezzo_unitario: libro.prezzo_copertina )
      #     new_righe.delete(r)
      #   end
      #   self.note = new_righe.join() 
      # end
    end

  
    def update_righe_status
      
      if stato == 'X'
        righe.each do |riga|
          riga.update_attributes({:pagato => true, :consegnato => true})
        end
      elsif stato == 'P'
        righe.each do |riga|
          riga.update_attributes({:pagato => false, :consegnato => true})
        end
      else
        righe.each do |riga|
          riga.update_attributes({:pagato => false, :consegnato => false})
        end
      end
    end

    def update_cliente_properties
      cliente.ricalcola_properties
    end

end



# == Schema Information
#
# Table name: appunti
#
#  id             :integer         not null, primary key
#  destinatario   :string(255)
#  note           :text
#  stato          :string(255)     default(""), not null
#  scadenza       :date
#  cliente_id     :integer
#  user_id        :integer
#  position       :integer
#  telefono       :string(255)
#  email          :string(255)
#  totale_copie   :integer         default(0)
#  totale_importo :float           default(0.0)
#  latitude       :float
#  longitude      :float
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#

