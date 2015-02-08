require 'test_helper'

class FatturaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
#  status               :string(255)
#

