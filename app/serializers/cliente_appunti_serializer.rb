class ClienteAppuntiSerializer < ActiveModel::Serializer
  
  attributes :id, :titolo, :cliente_tipo, 
           :frazione, :comune, :provincia, :indirizzo, :cap, 
           :ragione_sociale, :nome, :cognome, :abbr, 
           :telefono, :telefono_2, :fax, :email, :latitude, :longitude

  has_many :appunti
  has_many :classi

  def appunti
  	object.appunti.order("appunti.id desc")
  end
  
  def classi
  	object.classi.order("classi.classe, classi.sezione")
  end

end
