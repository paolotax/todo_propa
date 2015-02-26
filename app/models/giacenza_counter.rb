class GiacenzaCounter

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming


  attr_accessor :user, :anno, :params
  

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  def scarichi
    user.righe_documento.scarico
  end

  def carichi
    user.righe_documento.carico
  end

  def libri

    libri = user.righe_documento.pluck(:libro_id).uniq.map

    # libri = user.righe_documento.pluck(:libro_id).uniq.map
  end


end