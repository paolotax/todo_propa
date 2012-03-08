attributes :id, :destinatario, :note, :telefono, :email, :stato, :totale_copie, :totale_importo, :updated_at, :created_at

code do |u|
  { 
    cliente_id:   u.cliente_id,
    destinatario: u.destinatario.present? ? u.destinatario : "...",
    cliente_nome: u.cliente_nome,
    note:         markdown(u.note),
    stato:        stato_to_s(u),
    con_recapiti: u.has_recapiti?,
    con_righe:    u.has_righe?,
    auth_token:   form_authenticity_token 
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

child(:user)   { attributes :username }
child(:cliente) { attributes :id, :titolo, :frazione, :comune, :provincia }