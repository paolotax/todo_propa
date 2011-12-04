extends 'appunti/base'

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

child(:user)   { attributes :username }
child(:scuola) { attributes :id, :nome, :citta, :provincia }