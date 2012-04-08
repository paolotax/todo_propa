class Classe < ActiveRecord::Base
  
  belongs_to :cliente
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
  
  def update_nr_copie
    self.adozioni.scolastico.each do |a|
      a.update_attributes(:nr_copie => self.nr_alunni)
    end
  end
  
end
