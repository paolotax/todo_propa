class GiacenzaLibro


  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend  ActiveModel::Naming


  attr_accessor :user, :libro
  
  validates :user, :libro, presence: true

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end


  def scarichi
    @scarichi ||= user.righe.scarico.del_libro( libro )
  end

  
  def scarichi_non_registrati
    scarichi.select{|r| r.documento.class == Appunto}
  end

  
  def carichi
    @carichi ||= user.righe_documento.carico.del_libro( libro )
  end


  def copie_caricate
    carichi.map(&:quantita).sum
  end

  def copie_vendute
    scarichi.map(&:quantita).sum
  end

  def giacenza
    copie_caricate - copie_vendute
  end


  def carichi_per_anno
    carichi.sort_by{|x| x.data_da_raggruppare }.reverse.group_by{|r| r.data_da_raggruppare.year}
  end


  def scarichi_per_anno
    scarichi.sort_by{|x| x.data_da_raggruppare }.reverse.group_by{|r| r.data_da_raggruppare.year}
  end


  def anni_movimentati
    (carichi_per_anno.keys + scarichi_per_anno.keys).uniq.sort.reverse
  end


  def carico_scarico

    anni_movimentati.map do |anno|
      
      c  = handle_nil(carichi_per_anno.values_at(anno))
      s = handle_nil(scarichi_per_anno.values_at(anno)).group_by(&:state)

      copie_caricate = c.map(&:quantita).sum
      copie_vendute  = s.values.flatten.map(&:quantita).sum
      giacenza = copie_caricate - copie_vendute

      fatturati = handle_nil(s.values_at('registrata'))
      corrispettivi = handle_nil(s.values_at('open'))
      da_registrare = handle_nil(s.values_at('consegnata'))

      giacenza_contabile = giacenza + corrispettivi.map(&:quantita).sum + da_registrare.map(&:quantita).sum 

      {
        anno: anno,
        carichi: c,
        scarichi: s,
        copie_caricate: copie_caricate,
        copie_vendute:  copie_vendute,
        giacenza: giacenza,
        fatturati: fatturati,
        corrispettivi: corrispettivi,
        da_registrare: da_registrare
      }
    end
  end


  private

    def handle_nil(data)
      if data == [nil]
        []
      else
        data.flatten
      end
    end

end