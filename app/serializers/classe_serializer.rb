class ClasseSerializer < ActiveModel::Serializer

  attributes  :id, :classe, :sezione, :nr_alunni, :cliente_id

  # workaround for wrong json attribute
  def classe
    object.classe
  end

end