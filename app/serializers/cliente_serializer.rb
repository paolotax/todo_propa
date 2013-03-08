class ClienteSerializer < ActiveModel::Serializer
  attributes :id, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email, :latitude, :longitude,
           :partita_iva, :codice_fiscale

  #has_many :appunti

end
