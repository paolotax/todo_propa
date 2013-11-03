class ClienteAppuntiSerializer < ActiveModel::Serializer
  
  attributes :id, :uuid, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email, :latitude, :longitude

  has_many :appunti
  has_many :classi
  #has_many :docenti

  def appunti
  	object.appunti.order("appunti.id desc")
  end
  
  def classi
  	object.classi.order("classi.classe, classi.sezione")
  end

  attributes :docenti

  def docenti
    object.appunti.select('appunti.destinatario as "docente", appunti.telefono').order(:destinatario).uniq
  end

end
