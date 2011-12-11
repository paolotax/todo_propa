attributes :id, :destinatario, :note, :telefono, :email, :stato

code do |u|
  { 
    scuola_id:    u.scuola_id,
    destinatario: u.destinatario.present? ? u.destinatario : "...",
    scuola_nome:  u.scuola_nome,
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
child(:scuola) { attributes :id, :nome, :citta, :provincia }