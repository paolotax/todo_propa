extends 'libri/base'

object @libro

child :righe do |u|
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
  child :appunto do |u|
    attributes :id, :destinatario, :note, :totale_copie, :totale_importo, :stato
  end
  child :fattura do |u|
    attributes :id, :data, :pagata, :causale
  end
  child :cliente do |u|
    attributes :id, :titolo, :citta, :provincia
  end   
end