class Appunto < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :cliente
  
  has_many :righe, :dependent => :destroy
  
  has_many :visita_appunti, dependent: :destroy
  has_many :visite, :through => :visita_appunti
  
  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => true
  
  #  validates :user_id,  :presence => true
  validates :cliente_id,    :presence => true


  scope :recente,  order("appunti.id desc")
  scope :in_corso,   where("appunti.stato <> 'X'")
  scope :completo,   where("appunti.stato = 'X'")
  scope :da_fare,    where("appunti.stato = ''")
  scope :in_sospeso, where("appunti.stato = 'P'")
  
  scope :uniq_cliente_id, select(:cliente_id).uniq
  
  scope :recente_da_data, lambda { |data| includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?", data)  }
  scope :un_anno, lambda {  includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?",  1.year.ago)  }
  
  
  include PgSearch
  pg_search_scope :search, against: [:destinatario, :note],
    using: {tsearch: {dictionary: "italian"}},
    associated_against: {cliente: [ :titolo, :comune, :frazione, :provincia ] },
    order_within_rank: "updated_at DESC"
  
  
  before_save :leggi
  
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
  
  def has_righe?
    !self.righe.empty?
  end
  
  def has_recapiti?
   !self.telefono.blank? || !self.email.blank?
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
    appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
  
    appunti
    
    # raise appunti.inspect  if params[:search].present?
  end
  
  before_save :ricalcola
  
  def ricalcola
    self.totale_copie    = righe.map(&:quantita).sum
    self.totale_importo  = righe.map(&:importo).sum
  end

  after_save :update_righe_status
  
  private

    def leggi
    
      new_righe = self.note.lines.to_a
      for r in self.note.lines do
        riga = r.squish.split
        if /\d{5}[A-Z]/.match riga.first
          libro = Libro.find_or_create_by_cm( cm: riga.first, titolo: riga[1..-2].join(" "), prezzo_consigliato: 0, prezzo_copertina: 0 )
          new_riga = self.righe.build( libro: libro, quantita:  riga.last, prezzo_unitario: libro.prezzo_copertina )
          new_righe.delete(r)
        end
        self.note = new_righe.join() 
      end
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

