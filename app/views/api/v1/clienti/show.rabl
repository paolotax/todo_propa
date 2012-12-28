object @cliente

attributes :id, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email

child @appunti_in_corso => :appunti do |u|

  attributes :id, :note, :telefono, :email, 
             :stato, :totale_copie, :totale_importo, 
             :updated_at, :created_at

  code do |u|
    { 
      cliente_id:   u.cliente_id,
      destinatario: u.destinatario.present? ? u.destinatario : "...",
      cliente_nome: u.cliente_nome,
      stato:        u.status,
      con_recapiti: u.has_recapiti?,
      nel_baule:    u.nel_baule,
      con_righe:    u.has_righe?,
      tag_list:     u.tag_list
    }
  end

	node :errors do |model|
	   model.errors
	end

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
	end
end