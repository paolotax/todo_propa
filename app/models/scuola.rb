class Scuola < ActiveRecord::Base
  
  extend FriendlyId
  friendly_id :nome
  
  belongs_to :user

  has_many :appunti
  has_many :indirizzi, :as => :indirizzable, :dependent => :destroy
  
  validates :nome,  :presence => true,
                    :uniqueness => { :message => "gia' utilizzato!" } # { :scope => :user_id, :message => "gia' utilizzato!" }
  validates :citta,        :presence => true
  validates :provincia,    :presence => true, :length => { :is => 2 }
  
  scope :select_provincia, select("distinct scuole.provincia").group("scuole.provincia")
  scope :select_citta,     select("distinct scuole.citta").group("scuole.citta") 
  
  scope :con_appunti_in_corso,   joins(:appunti).where("appunti.stato <> 'X'")
  scope :con_appunti_completo,   joins(:appunti).where("appunti.stato = 'X'")
  scope :con_appunti_da_fare,    joins(:appunti).where("appunti.stato = ''")
  scope :con_appunti_in_sospeso, joins(:appunti).where("appunti.stato = 'P'")
  
  def to_s
    "##{id} - #{nome} #{citta} (#{provincia})"
  end
  
  def indirizzo
    self.indirizzi.first
  end
  
  def self.filtra(params)

    scuole = scoped
    scuole = scuole.where("scuole.nome ilike ?  or scuole.citta ilike ?", 
                          "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    scuole = scuole.where("scuole.provincia = ?", params[:provincia]) if params[:provincia].present?
    scuole = scuole.where("scuole.citta = ?",     params[:citta])     if params[:citta].present?
    scuole = scuole.joins(:appunti).con_appunti_in_corso   if params[:status].present? && params[:status] == 'in_corso'
    scuole = scuole.joins(:appunti).con_appunti_completo   if params[:status].present? && params[:status] == "completati"
    scuole = scuole.joins(:appunti).con_appunti_da_fare    if params[:status].present? && params[:status] == "da_fare"
    scuole = scuole.joins(:appunti).con_appunti_in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    scuole
  end
  
end
