class ClienteShortSerializer < ActiveModel::Serializer
  attributes :id, :appunti_in_sospeso, :appunti_da_fare

  def appunti_in_sospeso
  	object.properties[:appunti_in_sospeso] if object.properties
  end

  def appunti_da_fare
  	object.properties[:appunti_da_fare] if object.properties
  end

end