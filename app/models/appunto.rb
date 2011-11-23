class Appunto < ActiveRecord::Base
  belongs_to :scuola
  
 #  validates :user_id,  :presence => true
  validates :scuola_nome,  :presence => true

  scope :recente,  order("appunti.id desc")
  scope :in_corso,   includes(:scuola).where("appunti.stato <> 'X'")
  scope :completo,   includes(:scuola).where("appunti.stato = 'X'")
  scope :da_fare,    includes(:scuola).where("appunti.stato = ''")
  scope :in_sospeso, includes(:scuola).where("appunti.stato = 'P'")
  
  def to_s
    "##{id} - #{destinatario} (#{scuola_nome})"
  end
  
  # def to_param
  #   "#{id} #{destinatario} (#{scuola_nome})"
  # end
  
  def scuola_nome
    scuola.nome if scuola.present?
  end
  
  def self.filtra(params)
    appunti = scoped
    appunti = appunti.where("appunti.destinatario ilike ? or scuole.nome ilike ?  or scuole.citta ilike ?  or appunti.note ilike ?", 
               "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%") if params[:search].present?
    appunti = appunti.where("scuole.provincia = ?", params[:provincia]) if params[:provincia].present?
    appunti = appunti.where("scuole.citta = ?",     params[:citta])     if params[:citta].present?
    appunti = appunti.in_corso   if params[:status].present? && params[:status] == 'in_corso'
    appunti = appunti.completo   if params[:status].present? && params[:status] == "completati"
    appunti = appunti.da_fare    if params[:status].present? && params[:status] == "da_fare"
    appunti = appunti.in_sospeso if params[:status].present? && params[:status] == "in_sospeso"
    
    appunti
  end
end
