class Materia < ActiveRecord::Base
  
  # has_many :adozioni, :through => :libri, dependent: :nullify
  has_many :libri, dependent: :nullify
  

  def to_s
    materia
  end 

  # for delegate in Libro same name error
  def materia_libro
    materia
  end


  def classifica_adozioni(user)

    user.adozioni.where("libri.materia_id = ?", self.id).group_by {|a|  a.libro }.map {|k, v| {libro: k, nr_sezioni: v.size, nr_copie: v.sum(&:nr_copie)}} .sort_by { |v| v[:nr_sezioni] }.reverse

  end

  def self.cambia_materie_sussi

    # da usare solo una volta

    m_2 = Materia.create materia: "SUSSIDIARIO 2", ordine: 2, gruppo: "25"
    Materia.where(id: m_2.id).update_all(id: 50002)
    Libro.where(materia_id: 50202).update_all(materia_id: 50002)

    m_3 = Materia.create materia: "SUSSIDIARIO 3", ordine: 3, gruppo: "3"
    Materia.where(id: m_3.id).update_all(id: 50003)
    Libro.where(materia_id: 50203).update_all(materia_id: 50003)

  end

end
