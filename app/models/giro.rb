class Giro

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :giorno, :user_id, :baule
  
  validates_presence_of :giorno, :user_id
  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  def user
    user ||= User.find(@user_id)
  end
  
  def ieri
    (@giorno - 1.day).to_date
  end
  
  def domani
    (@giorno + 1.day).to_date
  end
  
  def visite
    if baule
      user.visite.includes(:cliente).where(baule: true)
    else  
      user.visite.includes(:cliente).where("date(start) = ?", @giorno).order(:start)
    end
  end
  
  def clienti
    visite.map(&:cliente)
  end
  
  def localita
    clienti.group_by { |c| c.localita }.keys
  end
  
  def appunti_da_fare
    user.appunti.da_fare.where("appunti.cliente_id in (?)", clienti.map(&:id))
  end
  
  def appunti_in_sospeso
    user.appunti.in_sospeso.where("appunti.cliente_id in (?)", clienti.map(&:id))
  end
  
  def righe_da_consegnare
    user.righe.includes(:libro).where("righe.appunto_id in (?)", appunti_da_fare.map(&:id))
  end
  
  def titoli_da_consegnare
    righe_da_consegnare.order("libri.titolo").group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, quantita: righe_da_consegnare.sum(&:quantita), importo: righe_da_consegnare.sum(&:importo)}
    end
  end
  
  def righe_in_sospeso
    user.righe.in_sospeso.joins(:libro, :appunto => :visite).where("date(start) = ?", @giorno)
  end  
  
  def adozioni
    user.mie_adozioni.includes(:libro).joins(:classe).where("classi.cliente_id in (?)", clienti.map(&:id)).order("libri.materia_id, libri.titolo, classi.sezione")
  end
  
  def adozioni_per_titolo
    adozioni.group_by(&:libro).map do |libro, adoz |
      { id: libro.id, titolo: libro.titolo, quantita: adoz.count(&:classe) }
    end
  end
  
  
end