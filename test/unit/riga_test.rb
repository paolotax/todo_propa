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
#  appunto_id      :integer
#  magazzino_id    :integer
#  movimento       :integer
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  uuid            :string
#  importo         :decimal(9, 2)   default(0.0)
#  state           :string(255)
#  position        :integer
#  pagata_il       :date
#  consegnata_il   :date
#  documento_id    :integer
#

