# == Schema Information
# Schema version: 20110808105615
#
# Table name: libri
#
#  id                 :integer         not null, primary key
#  titolo             :string(255)
#  materia_id         :integer
#  created_at         :datetime
#  updated_at         :datetime
#  sigla              :string(255)
#  prezzo_copertina   :integer
#  prezzo_consigliato :integer
#  currency           :string(255)
#  coefficente        :float
#  cm                 :string(255)
#  type               :string(255)
#

class Scorrimento < Libro
  
end
