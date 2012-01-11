class Appunto < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :scuola
  
  has_many :righe, :dependent => :destroy
  
  accepts_nested_attributes_for :righe, :reject_if => lambda { |a| (a[:quantita].blank? || a[:libro_id].blank?)}, :allow_destroy => true
  
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
  
  
  def appunto_for_mustache(appunto)
    
    righe = []
    
    appunto.righe.each do |r|
      riga = {

                        id:              r.id,
                        titolo:          r.libro.titolo,
                        quantita:        r.quantita,
                        prezzo_unitario: r.prezzo_unitario,
                        importo:         r.importo
              }
      righe << riga
    end

    {
      scuola_id:      appunto.scuola_id,
      id:             appunto.id, 
      destinatario:   appunto.destinatario.present? ? appunto.destinatario : "...",
      scuola_nome:    appunto.scuola_nome,
      note:           appunto.note,
      stato:          'stato_to_s(appunto)',
      telefono:       appunto.telefono,
      email:          appunto.email,
      con_recapiti:   appunto.telefono.present? || appunto.email.present? ? "con_recapiti" : "senza_recapiti",
      auth_token:     'form_authenticity_token',
      totale_copie:   appunto.totale_copie,
      totale_importo: appunto.totale_importo,
      righe:        righe
    }
  end
  
  
  
  
end
