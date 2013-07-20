class Adozione < ActiveRecord::Base

  belongs_to :classe
  belongs_to :libro
  belongs_to :cliente
  belongs_to :materia

  validates :classe_id, :uniqueness => {:scope => [:materia_id, :libro_id],
                                        :message => "e' gia' stata utilizzata"}  
                                        
                                        
  scope :scolastico, joins(:libro).where("libri.settore = 'Scolastico'")
  # scope :per_scuola, lambda {|s| }
  
  scope :per_classe_e_sezione, joins(:classe).order("classi.classe, classi.sezione, adozioni.materia_id")
  
  scope :con_kit,    where("kit_1 == 'consegnato' AND kit_2 == 'consegnato'")
  scope :con_saggio, where("kit_1 == 'consegnato' AND kit_2 != 'consegnato'")
  scope :vuota,      where("kit_1 != 'consegnato' AND kit_2 != 'consegnato'")


  def importo
    libro.prezzo_copertina * classe.nr_alunni
  end
  
  def titolo
    libro.titolo
  end
  
  def quantita
    1
  end
  
  def after_save
    self.update_counter_cache
  end

  def after_destroy
    self.update_counter_cache
  end

  def update_counter_cache
    self.classe.cliente.mie_adozioni_counter = Adozione.joins(:classe).scolastico.where("classi.cliente_id = ?", self.classe.cliente.id).count
    self.classe.cliente.save
  end

end
