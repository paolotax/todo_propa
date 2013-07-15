class ClasseSerializer < ActiveModel::Serializer

  attributes  :id, :classe, :sezione, :nr_alunni, :cliente_id, 
              :insegnanti, :note,
              :libro_1, :libro_2, :libro_3, :libro_4, :anno,
              :created_at, :updated_at

  #has_many :adozioni

  # workaround for wrong json attribute
  def classe
    object.classe
  end

  has_one :cliente, serializer: ClienteShortSerializer

  # def adozioni
  # 	object.adozioni.scolastico
  # end
end