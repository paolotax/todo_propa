module AppuntiHelper
  
  def appunto_for_mustache(appunto)
    
    righe = []
    
    appunto.righe.each do |r|
      riga = {
                riga: {
                        id:              r.id,
                        titolo:          r.libro.titolo,
                        quantita:        r.quantita,
                        prezzo_unitario: r.prezzo_unitario,
                        importo:         r.importo
                      }
              }
      righe << riga
    end

    {
      scuola_id:      appunto.scuola_id,
      id:             appunto.id, 
      destinatario:   appunto.destinatario.present? ? appunto.destinatario : "...",
      scuola_nome:    appunto.scuola_nome,
      note:           markdown(appunto.note),
      stato:          stato_to_s(appunto),
      telefono:       appunto.telefono,
      email:          appunto.email,
      con_recapiti:   appunto.telefono.present? || appunto.email.present? ? "con_recapiti" : "senza_recapiti",
      auth_token:     form_authenticity_token,
      totale_copie:   appunto.totale_copie,
      totale_importo: appunto.totale_importo,
      righe:        righe
    }
  end
  
  def appunto_rabl_for_mustache(appunto)
    
    source = File.read('appunto_json.rabl')
    rabl_engine = Rabl::Engine.new(source, :format => 'json')
    output = rabl_engine.render(self, {})
    
    # render :file => 'appunti/appunto_json', :object => appunto
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
