class Appunto < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :cliente
  
  has_many :righe, :dependent => :destroy
  
  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => true
  
  #  validates :user_id,  :presence => true
  validates :cliente_nome,  :presence => true

  scope :recente,  order("appunti.id desc")
  scope :in_corso,   includes(:cliente).where("appunti.stato <> 'X'")
  scope :completo,   includes(:cliente).where("appunti.stato = 'X'")
  scope :da_fare,    includes(:cliente).where("appunti.stato = ''")
  scope :in_sospeso, includes(:cliente).where("appunti.stato = 'P'")
  
  scope :uniq_cliente_id, select(:cliente_id).uniq
  
  scope :recente_da_data, lambda { |data| includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?", data)  }
  scope :un_anno, lambda {  includes(:cliente).where("appunti.stato <> 'X' or appunti.updated_at >= ?",  1.year.ago)  }
  
  
  before_save :leggi
  
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
    appunti = appunti.where("appunti.destinatario ilike ? or clienti.nome ilike ?  or clienti.comune ilike ? or clienti.frazione ilike ? or appunti.note ilike ?", 
               "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    appunti = appunti.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    appunti = appunti.where("clienti.comune = ?",    params[:comune])    if params[:comune].present?
    appunti = appunti.in_corso   if params[:status].present? && params[:status] == 'in_corso'
    appunti = appunti.completo   if params[:status].present? && params[:status] == "completati"
    appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    
    appunti
  end

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

