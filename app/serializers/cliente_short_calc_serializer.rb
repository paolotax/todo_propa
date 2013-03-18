class ClienteShortCalcSerializer < ActiveModel::Serializer
  attributes :id, :appunti_in_sospeso, :appunti_da_fare

  def appunti_in_sospeso
  	Cliente.find(object.id).properties[:appunti_in_sospeso]
  end

  def appunti_da_fare
  	Cliente.find(object.id).properties[:appunti_da_fare]
  end

end