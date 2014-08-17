class LibriInserter

  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  
  CORSI = {

    "SUSSIDIARIO 123" => {
        classi: [1, 2, 3],
        subtitle: [1, 2, 3],
        materie: [50001, 50202, 50203],
        copertina: [10.15, 14.30, 20.50]
      },
    "SUSSIDIARIO 45" => {
        classi: [4, 5],
        subtitle: [4, 5],
        materie: [50204, 50205],
        copertina: [16.20, 19.30]
      },
    "LETTURE 45" => {
        classi: [4, 5],
        subtitle: [4, 5],
        materie: [50004, 50005],
        copertina: [13.20, 16.00]
      },
    "RELIGIONE" => {
        classi: [1, 4],
        subtitle: [123, 45],
        materie: [50901, 50913],
        copertina: [6.25, 6.25]
      },
    "INGLESE" => {
        classi: [1,2,3,4,5],
        subtitle: [1, 2, 3, 4, 5],
        materie: [50401, 50402, 50403, 50404, 50405],
        copertina: [3.05, 5.00, 6.10, 6.10, 7.60]
      }
  }

  attr_accessor :titolo, :corso, :editore, :libri_inseriti
  
  validates_presence_of  :titolo, :corso, :editore
   
  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
  
  
  def insert_libri
    
    editore = Editore.find_or_create_by_nome(self.editore)
    classi  = CORSI[self.corso][:classi]
    materie = CORSI[self.corso][:materie]
    prezzi  = CORSI[self.corso][:copertina]
    subtitle =  CORSI[self.corso][:subtitle]

    classi.each_with_index do |c, index|
      libro = Libro.find_or_initialize_by_titolo("#{self.titolo} #{subtitle[index]}")
      libro.editore = editore
      libro.settore = "Concorrenza"
      libro.classe = classi[index]
      libro.materia_id = materie[index]
      libro.prezzo_copertina = prezzi[index]
      libro.save
      return false unless libro.errors.empty?
    end

    classi.each_with_index do |c, index|
      
      # dd = classi.index(c)
      
      if index  < classi.count

        

        libro = Libro.find_by_titolo("#{self.titolo} #{subtitle[index]}")
        seguito =  Libro.find_by_titolo("#{self.titolo} #{subtitle[index + 1]}")

        if seguito
          libro.next_id = seguito.id
        end
        
        libro.save
      end    
    end


    return true
  end  


  def persisted?
    false
  end
  

  
end