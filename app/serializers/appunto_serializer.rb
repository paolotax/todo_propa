class AppuntoSerializer < ActiveModel::Serializer
  
  attributes  :id, :destinatario, :note, :telefono, :email, :stato, 
  			  :totale_copie, :totale_importo, :updated_at, :created_at, :status, :cliente_nome

  has_many :righe

end
