require 'test_helper'

class LibroTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
# == Schema Information
#
# Table name: libri
#
#  id                 :integer         not null, primary key
#  autore             :string(255)
#  titolo             :string(255)
#  sigla              :string(255)
#  prezzo_copertina   :decimal(8, 2)
#  prezzo_consigliato :decimal(8, 2)
#  coefficente        :decimal(2, 1)
#  cm                 :string(255)
#  ean                :string(255)
#  old_id             :string(255)
#  settore            :string(255)
#  materia_id         :integer
#  image              :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#  slug               :string(255)
#  iva                :string(255)
#  classe             :integer
#  editore_id         :integer
#  next_id            :integer
#

