class RigaPostSerializer < ActiveModel::Serializer
  
  attributes  :id, 
          :appunto_id,
          :uuid, 
          :libro_id, 
          :titolo, 
          :quantita, 
          :prezzo_unitario, 
          :prezzo_copertina, 
          :prezzo_consigliato,  
          :sconto, 
          :importo,
          :fattura_id

end