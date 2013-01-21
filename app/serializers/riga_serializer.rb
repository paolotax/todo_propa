class RigaSerializer < ActiveModel::Serializer
  
  attributes  :id, :appunto_id, :titolo, :prezzo_unitario, :prezzo_copertina, :libro_id, 
  			  :quantita, :sconto

end
