class AppuntoPostSerializer < ActiveModel::Serializer
  
  attributes  :id, :totale_copie, :totale_importo, :cliente_id, :cliente_nome, :created_at, :updated_at

  has_one :cliente, serializer: ClienteShortCalcSerializer
end