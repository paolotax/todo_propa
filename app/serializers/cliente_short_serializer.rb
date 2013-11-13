class ClienteShortSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :appunti_in_sospeso, :appunti_da_fare
end