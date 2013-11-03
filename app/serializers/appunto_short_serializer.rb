class AppuntoShortSerializer < ActiveModel::Serializer
  
  attributes  :id, :uuid, :totale_copie, :totale_importo, :created_at, :updated_at

end