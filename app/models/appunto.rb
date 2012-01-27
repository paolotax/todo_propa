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
  
  
  def to_s
    "##{id} - #{destinatario} (#{cliente_nome})"
  end
  
  def to_param
    "#{id} #{destinatario} (#{cliente_nome})".parameterize
  end
  
  def cliente_nome
    cliente.nome if cliente.present?
  end
  
  def has_righe?
    !self.righe.empty?
  end
  
  def has_recapiti?
   !self.telefono.blank? || !self.email.blank?
  end
  
  def self.filtra(params)
    appunti = scoped
    appunti = appunti.where("appunti.destinatario ilike ? or clienti.nome ilike ?  or clienti.citta ilike ?  or appunti.note ilike ?", 
               "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    appunti = appunti.where("clienti.provincia = ?", params[:provincia]) if params[:provincia].present?
    appunti = appunti.where("clienti.citta = ?",     params[:citta])     if params[:citta].present?
    appunti = appunti.in_corso   if params[:status].present? && params[:status] == 'in_corso'
    appunti = appunti.completo   if params[:status].present? && params[:status] == "completati"
    appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    
    appunti
  end

end
