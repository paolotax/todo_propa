class Riga < ActiveRecord::Base
  belongs_to :appunto
  belongs_to :libro

  after_initialize :init
  after_save :ricalcola_totali
  after_destroy :ricalcola_totali


  delegate :titolo, :prezzo_copertina, :prezzo_consigliato, :to => :libro

  scope :per_libro_id, order("righe.libro_id")
  scope :da_consegnare, joins(:appunto).where("appunti.stato is null or appunti.stato = ''")
  scope :da_fatturare,  where("righe.fattura_id is null or righe.fattura_id = 0")
  
  def prezzo
    if sconto == 0.0
      prezzo_unitario
    else
      prezzo_copertina
    end
  end
  
  def remove_fattura=(value)
    if value == "true"
      self.fattura_id = nil
      self.save
    end
  end
  
  def prezzo=(text)
    self.prezzo_unitario = text
  end
  
  def importo
    sconto.nil? ? sc = 0.0 : sc = sconto
    prezzo_unitario * quantita * (100.0 - sc) / 100
  end
  
  private
  
    def init
      self.sconto ||= 0.0           #will set the default value only if it's nil
    end  
  
    def ricalcola_totali
      return true unless quantita_changed? || prezzo_unitario_changed? || fattura_id_changed? || sconto_changed?
      appunto.update_attributes(:totale_copie => appunto.righe.sum(:quantita), :totale_importo => appunto.righe.sum('righe.quantita * righe.prezzo_unitario * (100 - righe.sconto) / 100'))
      return true
    end

end


# == Schema Information
#
# Table name: righe
#
#  id              :integer         not null, primary key
#  libro_id        :integer
#  quantita        :integer
#  prezzo_unitario :decimal(9, 3)
#  sconto          :decimal(5, 2)   default(0.0)
#  consegnato      :boolean
#  pagato          :boolean
#  appunto_id      :integer
#  fattura_id      :integer
#  magazzino_id    :integer
#  causale_id      :integer
#  movimento       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

