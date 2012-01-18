attributes :id, :destinatario, :note, :telefono, :email, :stato, :totale_copie, :totale_importo

code do |u|
  { 
    cliente_id:    u.cliente_id,
    destinatario: u.destinatario.present? ? u.destinatario : "...",
    cliente_nome:  u.cliente_nome,
    note:         markdown(u.note),
    stato:        stato_to_s(u),
    con_recapiti: u.telefono.present? || u.email.present? ? "con_recapiti" : "senza_recapiti",
    auth_token:   form_authenticity_token 
  }
end


node :errors do |model|
   model.errors
end

child :righe do |u|
   attributes :id, :libro_id, :quantita, :prezzo_unitario, :sconto, :importo
   glue :libro do |l|
     attributes :titolo, :prezzo_copertina
   end
end

child(:user)   { attributes :username }
child(:cliente) { attributes :id, :nome, :citta, :provincia }