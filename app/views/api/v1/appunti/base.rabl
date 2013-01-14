attributes :id, :destinatario, :note, :telefono, :email, :stato, :totale_copie, :totale_importo, :updated_at, :created_at

code do |u|
  { 
    cliente_id:   u.cliente_id,
    destinatario: u.destinatario.present? ? u.destinatario : "...",
    cliente_nome: u.cliente_nome,
    status:       u.status,
    con_recapiti: u.has_recapiti?,
    nel_baule:    u.nel_baule,
    con_righe:    u.has_righe?,
    tag_list:     u.tag_list
  }
end

# code do |u|
#   unless u.nel_baule.nil?  
#     { nel_baule:    u.cliente.nel_baule.id }
#   end
# end

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

child(:user)    { attributes :username }
child(:cliente) { attributes :id, :titolo, :frazione, :comune, :provincia }

