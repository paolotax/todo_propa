module AppuntiHelper
  
  def appunto_for_mustache(appunto)
    {
      url:          appunto_url(appunto),
      url_scuola:   "#{scuola_url(appunto.scuola) if appunto.scuola.present?}",
      destinatario: appunto.destinatario,
      scuola_nome:  appunto.scuola_nome,
      note:         appunto.note,
      stato:        appunto.stato,
      telefono:     appunto.telefono,
      email:        appunto.email
    }
  end
  
  
end
