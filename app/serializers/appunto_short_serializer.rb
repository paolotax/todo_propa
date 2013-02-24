class AppuntoShortSerializer < ActiveModel::Serializer
  
  attributes  :id, :totale_copie, :totale_importo, :created_at, :updated_at

end