class Giro


  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :giorno, :user, :baule

  
  validates_presence_of :giorno, :user

  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  def visite
    if baule && baule == true
      user.visite.includes(:cliente).where(baule: true).order(:start)
    else  
      user.visite.includes(:cliente).where("data = ?", @giorno).order(:start)
    end
  end


  def baule?
    @baule == true
  end

  def salva_baule(params)

    if @baule == true

      visite.each_with_index do |visita, index|  
        unless visita.update_attributes(params[:visita].merge(step: index).reject { |k, v| v.blank? })
          # non modifica lo scopo se Cliente già visitato
          old_visita = Visita.find_by_cliente_id_and_data(visita.cliente_id, Date.parse(params[:visita][:data]))
          old_visita.add_scopo params[:visita][:scopo]
          old_visita.step = index
          old_visita.save 
          visita.destroy
        end
      end

    end
  
  end

  
  def clienti
    visite.map(&:cliente)
  end


  def clienti_vicini

    vicini = []

    clienti.each do |cliente|
      if cliente.latitude && cliente.longitude
        vicini << cliente.nearbys(10, units: :km).all
      end
    end
    clienti_vicini = (vicini.flatten - clienti) & user.clienti.con_qualcosa_da_fare(user)
  end

  
  def titoli
    visite.map(&:titolo).uniq.join(', ')
  end

  
  def scopo
    visite.map {|a| a.scopo.try(:split, ", ")}.uniq.reject {|a| a.nil?}.flatten.join(", ") 
  end


  def ieri
    (@giorno - 1.day).to_date
  end

  
  def domani
    (@giorno + 1.day).to_date
  end

    
  def localita
    clienti.group_by { |c| c.comune }.keys.join(", ") 
  end
  

  def appunti_da_fare
    appunti = user.appunti.not_deleted.da_fare.where("appunti.cliente_id in (?)", clienti.map(&:id))
    appunti_da_fare = []
    clienti.each do |cliente|
      appunti_da_fare << appunti.select{|a| a.cliente_id == cliente.id}
    end 
    appunti_da_fare.flatten
  end
  

  def appunti_in_sospeso
    appunti = user.appunti.not_deleted.in_sospeso.where("appunti.cliente_id in (?)", clienti.map(&:id))
    appunti_in_sospeso = []
    clienti.each do |cliente|
      appunti_in_sospeso << appunti.select{|a| a.cliente_id == cliente.id}
    end 
    appunti_in_sospeso.flatten
  end
  

  def appunti_preparato
    appunti = user.appunti.not_deleted.preparato.where("appunti.cliente_id in (?)", clienti.map(&:id))
    appunti_preparato = []
    clienti.each do |cliente|
      appunti_preparato << appunti.select{|a| a.cliente_id == cliente.id}
    end 
    appunti_preparato.flatten
  end


  def righe_da_consegnare
    user.righe.not_deleted.includes(:libro).where("righe.appunto_id in (?)", appunti_da_fare.map(&:id))
  end


  def copie_da_consegnare
    righe_da_consegnare.sum(&:quantita)
  end

  
  def importo_da_consegnare
    righe_da_consegnare.sum(&:importo)
  end


  def titoli_da_consegnare
    righe_da_consegnare.order("libri.titolo").group_by(&:libro).map do |libro,righe| 
      { id: libro.id, titolo: libro.titolo, quantita: copie_da_consegnare, importo: importo_da_consegnare}
    end
  end
  

  def righe_in_sospeso
    user.righe.not_deleted.in_sospeso.joins(:libro, :appunto => :visite).where("date(start) = ?", @giorno)
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