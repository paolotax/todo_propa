require 'spec_helper'

describe Documento do
  pending "add some examples to (or delete) #{__FILE__}"
end
# == Schema Information
#
# Table name: documenti
#
#  id                   :integer         not null, primary key
#  numero               :integer
#  data                 :date
#  note                 :string(255)
#  cliente_id           :integer
#  causale_id           :integer
#  user_id              :integer
#  condizioni_pagamento :string(255)
#  pagata               :boolean         default(FALSE)
#  totale_copie         :integer         default(0)
#  totale_importo       :decimal(9, 2)   default(0.0)
#  totale_iva           :decimal(9, 2)   default(0.0)
#  spese                :decimal(9, 2)   default(0.0)
#  status               :string(255)
#  slug                 :string(255)
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#

