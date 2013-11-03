class ClienteShortSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :appunti_in_sospeso, :appunti_da_fare

  # def appunti_in_sospeso
  #   Cliente.find(object.id).properties[:appunti_in_sospeso]
  # end

  # def appunti_da_fare
  #   Cliente.find(object.id).properties[:appunti_da_fare]
  # end
  
  # def appunti_in_sospeso
  # 	object.properties[:appunti_in_sospeso] if object.properties
  # end

  # def appunti_da_fare
  # 	object.properties[:appunti_da_fare] if object.properties
  # end

end