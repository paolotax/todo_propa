class Consegna

  
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :user, :data, :riga_ids, :causale, :azione, :pagata
  
  validates_presence_of :user, :riga_ids

  
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def esegui
    @righe = user.righe.find(riga_ids)

    @righe.each do |r|
      
      if azione == 'consegna'
        
        if r.can_consegna?
          r.update_attributes(consegnata_il: data)
          r.consegna
        end
        
        if pagata && pagata == '1' && r.can_paga?

          r.update_attributes(pagata_il: data)
          r.paga
        end

      elsif azione == 'paga'
        
        if r.can_paga? 
          r.update_attributes(pagata_il: data)
          r.paga
        end
      
      else
        r.send(azione.split.join("_").downcase)
      end
    end
  end


  def persisted?
    false
  end


end