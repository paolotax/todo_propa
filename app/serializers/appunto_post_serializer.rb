class AppuntoPostSerializer < ActiveModel::Serializer
  
  attributes  :id, :uuid, :totale_copie, :totale_importo, :cliente_id, :cliente_nome, :created_at, :updated_at

  #has_one :cliente, serializer: ClienteShortCalcSerializer
  has_many :righe, serializer: RigaPostSerializer
end