module AppuntiHelper
  
  def appunto_for_mustache(appunto)
    {
      url:          appunto_url(appunto),
      url_scuola:   "#{scuola_url(appunto.scuola) if appunto.scuola.present?}",
      id:           appunto.id, 
      destinatario: appunto.destinatario.present? ? appunto.destinatario : "...",
      scuola_nome:  appunto.scuola_nome,
      note:         markdown(appunto.note),
      stato:        stato_to_s(appunto),
      telefono:     appunto.telefono,
      email:        appunto.email,
      con_recapiti: appunto.telefono.present? || appunto.email.present? ? "con_recapiti" : "senza_recapiti",
      auth_token:   form_authenticity_token
    }
  end
  
  def stato_to_s(appunto)
    if appunto.stato == "P"
      "in_sospeso"
    elsif appunto.stato == "X"
      "completato"
    else
      "da_fare"
    end   
  end
  
  
end
