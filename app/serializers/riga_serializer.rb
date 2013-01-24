class RigaSerializer < ActiveModel::Serializer
  
  attributes  :id, :appunto_id, :libro_id, :titolo, 
  			  :quantita, 
  			  :prezzo_unitario, :prezzo_copertina, :prezzo_consigliato,  
  			  :sconto, :importo

end
