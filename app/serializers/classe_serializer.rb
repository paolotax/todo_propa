class ClasseSerializer < ActiveModel::Serializer

  attributes  :id, :classe, :sezione, :nr_alunni, :cliente_id

  has_many :adozioni

  # workaround for wrong json attribute
  def classe
    object.classe
  end

  def adozioni
  	object.adozioni.scolastico
  end
end