class Consegna

  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :user, :data, :riga_ids, :causale, :azione, :group, :stampa
  
  validates_presence_of :user, :riga_ids

  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  
  def esegui
    
    righe.each do |r|
      if azione == 'consegna'
        r.consegna_in_data(data)
      elsif azione == 'paga'
        r.paga_in_data(data)
      elsif azione == 'consegna e paga'
        r.consegna_in_data(data)
        r.paga_in_data(data)
      elsif azione == 'registra'
        r.registra_con_documento nil
      else
        r.send(azione.split.join("_").downcase)
      end
    end

    # if stampa == true
    #   pdf = AppuntoPdf.new(appunti, view_context)
    #   send_data pdf.render, filename: "sovrapacchi_#{Time.now}.pdf",
    #                           type: "application/pdf",
    #                           disposition: "inline"
    # end
  end


  def righe_grouped(group = :cliente)
    righe.select{|r| r.can_registra?}.group(&:cliente).each do |key, values|

    end

  end


  def clienti
    @clienti ||= righe.select{|r| r.can_registra?}.map(&:cliente).uniq
  end


  def righe
    @righe ||= user.righe.find(riga_ids)
  end


  def appunti
    @appunti ||= @righe.select(&:appunto).uniq
  end


  def registra_con_documento

  end


  def persisted?
    false
  end


end