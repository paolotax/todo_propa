attributes :id, :numero, :causale, :condizioni_pagamento, :pagata, :totale_copie, :totale_iva, :spese, :slug


node(:data)            {|u| l(u.data, format: :short).downcase}
node(:importo_fattura) {|u| number_to_currency(u.importo_fattura)}



node :errors do |model|
   model.errors
end

child :righe_per_titolo => :righe do |u|
  attributes :id, :libro_id, :quantita
  node :prezzo_unitario do |u|
    u.prezzo_unitario.round(2)
  end
  node :sconto do |u|
    u.sconto.round(2)
  end
  node :importo do |u|
    u.importo.round(2)
  end 
  glue :libro do |l|
    attributes :titolo, :prezzo_copertina
  end
end

child(:user)   { attributes :username }

child(:cliente) do |c|
  attributes :id, :titolo, :frazione, :comune, :provincia
  node(:cliente_url) { |cliente| cliente_url(cliente) }
end
     
    
  
  
