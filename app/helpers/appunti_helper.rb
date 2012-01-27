module AppuntiHelper
  
  def appunto_for_mustache(appunto)
    
    righe = []
    
    appunto.righe.each do |r|
      riga = {
                        id:              r.id,
                        titolo:          r.libro.titolo,
                        quantita:        r.quantita,
                        prezzo_unitario: r.prezzo_unitario.round(2),
                        sconto:          r.sconto.round(2),
                        importo:         r.importo.round(2)
             }
      righe << riga
    end

    {
      cliente_id:      appunto.cliente_id,
      id:             appunto.id, 
      destinatario:   appunto.destinatario.present? ? appunto.destinatario : "...",
      cliente_nome:   appunto.cliente_nome,
      note:           markdown(appunto.note),
      stato:          stato_to_s(appunto),
      telefono:       appunto.telefono,
      email:          appunto.email,
      con_recapiti:   appunto.has_recapiti?,
      auth_token:     form_authenticity_token,
      totale_copie:   appunto.totale_copie,
      totale_importo: appunto.totale_importo.round(2),
      con_righe:      appunto.has_righe?, 
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
