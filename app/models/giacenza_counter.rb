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
    @scarichi ||= user.righe.scarico.dell_anno(anno).joins(:libro).includes(:libro).order("libri.titolo").group_by(&:libro)
  end


  def carichi
    @carichi ||= user.righe_documento.carico.dell_anno(anno).joins(:libro).includes(:libro).order("libri.titolo").group_by(&:libro)
  end

  
  def libri
    (carichi.keys + scarichi.keys).flatten.uniq.sort_by(&:titolo)
  end

  
  def data
    @data ||= begin
      @data = []
      libri.each do |libro|
        c =  handle_nil_array(carichi.values_at(libro))
        s =  handle_nil_array(scarichi.values_at(libro)).group_by(&:state)
        @data << OpenStruct.new(
          libro: libro, 
          carichi: c, 
          scarichi: s,
          copie_caricate: c.map(&:quantita).sum,
          copie_vendute:  s.values.flatten.map(&:quantita).sum,
          giacenza:       c.map(&:quantita).sum - s.values.flatten.map(&:quantita).sum,
          copie_consegnate:    handle_nil_array(s.values_at('consegnata')).map(&:quantita).sum + handle_nil_array(s.values_at('pronta')).map(&:quantita).sum + handle_nil_array(s.values_at('open')).map(&:quantita).sum,
          copie_corrispettivi: handle_nil_array(s.values_at('corrispettivi')).map(&:quantita).sum,
          copie_registrate:    handle_nil_array(s.values_at('registrata')).map(&:quantita).sum
        )
      end
      @data
    end
  end


  def per_settore
    data.group_by{|l| l.libro.settore}
  end

  
  def persisted?
    false
  end


  private

    def handle_nil_array(data)
      if data == [nil] || data.nil?
        []
      else
        data.flatten
      end
    end


end