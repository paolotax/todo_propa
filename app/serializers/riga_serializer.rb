class RigaSerializer < ActiveModel::Serializer
  
  attributes :id,
             :uuid, 
      		   :appunto_id, 
             :libro_id, 
      			 :titolo, 
    		  	 :quantita, 
      			 :prezzo_unitario, 
      			 :prezzo_copertina, 
      			 :prezzo_consigliato,  
      			 :sconto, 
             :importo,
      			 :fattura_id,
             :state

  has_one :libro, serializer: LibroShortSerializer

end
