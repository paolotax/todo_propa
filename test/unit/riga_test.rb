require 'test_helper'

class RigaTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
#  created_at      :datetime
#  updated_at      :datetime
#

