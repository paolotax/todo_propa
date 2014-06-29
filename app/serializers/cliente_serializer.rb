class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :uuid, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email, :latitude, :longitude,
           :partita_iva, :codice_fiscale,
           :appunti_in_sospeso,
           :appunti_da_fare,
           :nel_baule,
           :fatto,
           :visita,
           :updated_at,
           :created_at,
           :deleted_at

  #has_many :appunti

  def nel_baule
  	if object.nel_baule.nil?
  	  false
  	else
  	  true
  	end
  end

  def fatto
    object.fatto?
  end

  def visita
    object.visita.try(:start) || nil
  end

end
