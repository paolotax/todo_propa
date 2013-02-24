class AppuntoSerializer < ActiveModel::Serializer
  
  attributes  :id, :destinatario, :note, :telefono, :email, :stato,
  			  :totale_copie, :totale_importo, :status, :cliente_id, :cliente_nome,
  			  :created_at, :updated_at

  #has_many :righe
  has_one :cliente

end
