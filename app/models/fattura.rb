class Fattura < ActiveRecord::Base

  belongs_to :cliente
  belongs_to :user
  
  has_many :righe, :dependent => :nullify
  has_many :appunti, :through => :righe
  
  validates :data, :presence => true
  validates :numero, :presence => true
  
  scope :per_numero, order('fatture.data desc, fatture.numero desc')

end

# == Schema Information
#
# Table name: fatture
#
#  id                   :integer         not null, primary key
#  numero               :integer
#  data                 :date
#  cliente_id           :integer
#  user_id              :integer
#  causale_id           :integer
#  condizioni_pagamento :string(255)
#  pagata               :boolean
#  totale_copie         :integer         default(0)
#  importo_fattura      :decimal(9, 2)
#  totale_iva           :decimal(9, 2)   default(0.0)
#  spese                :decimal(9, 2)   default(0.0)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  slug                 :string(255)
#

