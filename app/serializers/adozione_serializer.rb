class AdozioneSerializer <  ActiveModel::Serializer

  attributes :id, :classe_id, :libro_id, :sigla

  def sigla
    object.libro.sigla
  end

  has_one :classe, serializer: ClasseShortSerializer
  has_one :libro,  serializer: LibroShortSerializer


end