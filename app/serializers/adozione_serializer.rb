class AdozioneSerializer <  ActiveModel::Serializer

  attributes :id, :classe_id, :libro_id, :sigla

  def sigla
    object.libro.sigla
  end


end