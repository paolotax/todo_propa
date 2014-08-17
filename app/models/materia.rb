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



end
