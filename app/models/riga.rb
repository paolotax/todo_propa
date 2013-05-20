class Riga < ActiveRecord::Base
  
  belongs_to :appunto
  belongs_to :libro
  belongs_to :fattura
  
  after_initialize :init
  # after_save :ricalcola_totali
  # after_destroy :ricalcola_totali

  delegate :titolo, :prezzo_copertina, :prezzo_consigliato, :iva, :to => :libro

  scope :per_libro_id,  order("righe.libro_id")
  scope :per_titolo,    joins(:libro).order("libri.titolo asc")
  scope :per_cm,        joins(:libro).order("libri.cm asc")
  scope :per_id,        order(:id)
  
  scope :scarico,       joins(:appunto)
  
  scope :da_consegnare, where("righe.consegnato = false")
  scope :da_pagare,     where("righe.pagato     = false")
  scope :da_fatturare,  where("righe.fattura_id is null")
  scope :fatturata,     where("righe.fattura_id is not null")
  scope :consegnata,    where("righe.consegnato = true")
  scope :pagata,        where("righe.pagato = true")
  
  scope :carico,        joins(:fattura).where("fatture.causale_id = ?", 3)
  
  scope :di_questa_propaganda,  where("righe.created_at >= ?", Date.new(2013,5,1))
  
  
  def riga_abbreviata
    self.libro.sigla + " " + self.quantita.to_s
  end  
  
  def documento
    self.appunto || self.fattura
  end
  
  def cliente
   self.appunto.cliente || self.fattura.cliente
  end
  
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
      self.consegnato ||= false
      self.pagato     ||= false
      self.sconto ||= 0.0           #will set the default value only if it's nil
    end  
  
    def ricalcola_totali
      logger.debug "ricalcola_totali"
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

