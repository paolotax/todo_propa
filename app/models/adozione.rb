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
  
  scope :per_stato,  order("kit_1, kit_2")
  scope :per_scuola, joins(:classe => :cliente).order("clienti.provincia, clienti.id, classi.classe, classi.sezione, adozioni.materia_id")
  
  scope :con_kit,    where("kit_1 == 'consegnato' AND kit_2 == 'consegnato'")
  scope :con_saggio, where("kit_1 == 'consegnato' AND kit_2 != 'consegnato'")
  scope :vuota,      where("kit_1 != 'consegnato' AND kit_2 != 'consegnato'")

  scope :del_libro,  lambda { |l| where("adozioni.libro_id = ?", l) }

  
  def importo
    libro.prezzo_copertina * classe.nr_alunni
  end
  
  def titolo
    libro.titolo
  end
  
  def quantita
    1
  end
  
  def stato
    if kit_1 == "consegnato" && kit_2 == "consegnato"
      "kit"
    elsif kit_1 == "consegnato" && kit_2 != "consegnato"
      "saggio"
    elsif kit_1 != "consegnato" && kit_2 == "consegnato"
      "kit no saggio"
    else 
      "da consegnare"
    end        
  end

  def self.filtra(params)
    adozioni = scoped
    adozioni = adozioni.joins(:libro).where("libri.materia_id = ?", params[:materia])  if params[:materia].present?
    adozioni = adozioni.joins(:libro).where("libri.titolo = ?", params[:titolo])  if params[:titolo].present?    
    adozioni
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
