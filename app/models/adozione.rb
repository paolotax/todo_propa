class Adozione < ActiveRecord::Base

  belongs_to :classe, touch: true
  belongs_to :libro
  
  has_one :cliente, through: :classe

  belongs_to :materia

  validates :classe_id, :uniqueness => {:scope => [:materia_id, :libro_id],
                                        :message => "e' gia' stata utilizzata"}                                          
  scope :scolastico, joins(:libro).where("libri.settore = 'Scolastico'")
  scope :concorrenza, joins(:libro).where("libri.settore = 'Concorrenza'")
  
  # scope :per_scuola, lambda {|s| }
  
  scope :per_classe_e_sezione, joins(:classe).order("classi.classe, classi.sezione, adozioni.materia_id")
  
  scope :per_stato,  order("kit_1, kit_2")
  scope :per_scuola, joins(:classe => :cliente).order("clienti.provincia, clienti.id, classi.classe, classi.sezione, adozioni.materia_id")
  
  scope :con_kit,    where("kit_1 == 'consegnato' AND kit_2 == 'consegnato'")
  scope :con_saggio, where("kit_1 == 'consegnato' AND kit_2 != 'consegnato'")
  scope :vuota,      where("kit_1 != 'consegnato' AND kit_2 != 'consegnato'")

  scope :del_libro,  lambda { |l| where("adozioni.libro_id = ?", l) }

  scope :ultima, order("adozioni.updated_at desc").limit(1)



  def importo
    libro.prezzo_copertina * nr_copie ||= 0
  end
  
  def titolo
    libro.titolo
  end

  def provincia
    classe.cliente.provincia
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
      "saggio+guida"
    else 
      "da consegnare"
    end        
  end

  
  def self.filtra(params)
    adozioni = scoped
    adozioni = adozioni.joins(libro: :editore, classe: :cliente).where("libri.materia_id = ?", params[:materia])  if params[:materia].present?
    
    adozioni = adozioni.joins(libro: :editore, classe: :cliente).where("libri.materia_id IN (?)", params[:materia_ids])  if params[:materia_ids].present?
    
    adozioni = adozioni.joins(:libro).where("libri.titolo = ?", params[:titolo])  if params[:titolo].present?
    adozioni = adozioni.joins(:classe => :cliente).where("clienti.provincia = ?", params[:provincia])  if params[:provincia].present?    
    adozioni
  end


  def self.delete_orphaned
    Adozione.where( "libro_id NOT IN (?) OR classe_id NOT IN (?) OR classe_id IS NULL or libro_id IS NULL", Libro.pluck("id"), Classe.pluck("id") ).destroy_all
  end

  
  after_save :update_cliente_properties
  
  
  private

    def update_cliente_properties
      classe.cliente.ricalcola_properties
    end


end
# == Schema Information
#
# Table name: adozioni
#
#  id         :integer         not null, primary key
#  classe_id  :integer
#  libro_id   :integer
#  materia_id :integer
#  nr_copie   :integer         default(0)
#  nr_sezioni :integer         default(0)
#  anno       :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#  kit_1      :string(255)
#  kit_2      :string(255)
#

