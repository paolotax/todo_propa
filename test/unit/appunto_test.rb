require 'test_helper'

class AppuntoTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: appunti
#
#  id             :integer         not null, primary key
#  destinatario   :string(255)
#  note           :text
#  stato          :string(255)     default(""), not null
#  scadenza       :date
#  cliente_id     :integer
#  user_id        :integer
#  position       :integer
#  telefono       :string(255)
#  email          :string(255)
#  totale_copie   :integer         default(0)
#  totale_importo :decimal(9, 2)   default(0.0)
#  latitude       :float
#  longitude      :float
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  uuid           :string
#  deleted_at     :datetime
#  completed_at   :datetime
#  nota           :string(255)
#  score          :integer
#  righe_count    :integer         default(0), not null
#

