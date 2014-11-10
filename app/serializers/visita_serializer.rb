class VisitaSerializer < ActiveModel::Serializer
  
  attributes :id,
             :all_day, 
             :baule,
             :start,
             :end,
             :data,
             :scopo,
             :titolo,
             :cliente,
             :localita,
             :longitude,
             :latitude


  def cliente
    object.cliente.titolo
  end

  
  def localita
    object.cliente.localita
  end

  
  def longitude
    object.cliente.longitude
  end

  
  def latitude
    object.cliente.latitude
  end


end