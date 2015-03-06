class Consegna

  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :user, :data, :riga_ids, :azione
  
  validates_presence_of :user, :riga_ids

  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def esegui
    @righe = user.righe.find(riga_ids)

    @righe.each do |r|
      r.update_attributes consegnata_il: data
      r.send(azione)
    end

  end


  def annulla
    @righe = user.righe.find(riga_ids)


    @righe.each do |r|
      r.update_attributes consegnata_il: nil
      r.annulla_consegna
    end
    
  end


  def righe
    user.righe.find(riga_ids)
  end



  def persisted?
    false
  end


end