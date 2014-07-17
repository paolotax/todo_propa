class Classe < ActiveRecord::Base
  
  belongs_to :cliente, touch: true
  
  has_many :adozioni,     :dependent => :destroy
  
  validates :sezione, :uniqueness => {:scope => [:classe, :cliente_id],
                                        :message => "e' gia' stata utilizzata"}
  
  after_save :update_nr_copie

  scope :per_scuola, lambda { 
    |sc| where('classi.cliente_id = ?', sc).order([:classe, :sezione])
  }
  
  def to_s
    "#{self.classe} #{self.sezione}"
  end

  def self.mercato
    classi = scoped

    classi = classi.select("count(classi.id) as totale_classi, sum(classi.nr_alunni) as totale_alunni, avg(classi.nr_alunni) as media_alunni").group(:classe)
    classi

  end
  
  def libri_adottabili
    libri = Libro.scolastico.where(classe: classe).order(:materia_id)
    materie = adozioni.joins(:libro).pluck("libri.materia_id").uniq
    libri_adottabili = libri.select {|l| materie.include?(l.materia_id) == false } 
    libri_adottabili
  end

  def update_nr_copie
    self.adozioni.readonly(false).each do |a|
      a.update_attributes(:nr_copie => self.nr_alunni)
    end
  end

  def self.espandi_sezioni

    classi_da_espandere = Classe.select { |c| c.sezione.length > 1 }

    classi_da_espandere.each do |classe|

      sez_ar = classe.sezione.split("")
      alunni = classe.nr_alunni
      media_alunni = alunni / sez_ar.size
      resto_alunni = alunni % sez_ar.size
      
      sez_ar.each_with_index do |sezione, index| 
        if index == 0
          classe.update_attributes( sezione: sezione, nr_alunni: media_alunni + resto_alunni)
        else
          Classe.create(
            cliente_id: classe.cliente_id,
            classe: classe.classe,
            sezione: sezione,
            nr_alunni: media_alunni
          )
        end  
      end  
    end
  end


  
end
