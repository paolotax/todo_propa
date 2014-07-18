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
      "kit no saggio"
    else 
      "da consegnare"
    end        
  end

  
  def self.filtra(params)
    adozioni = scoped
    adozioni = adozioni.joins(:libro).where("libri.materia_id = ?", params[:materia])  if params[:materia].present?
    adozioni = adozioni.joins(:libro).where("libri.titolo = ?", params[:titolo])  if params[:titolo].present?
    adozioni = adozioni.joins(:classe => :cliente).where("clienti.provincia = ?", params[:provincia])  if params[:provincia].present?    
    adozioni
  end


  def self.delete_orphaned
    Adozione.where( "libro_id NOT IN (?) OR classe_id NOT IN (?) OR classe_id IS NULL or libro_id IS NULL", Libro.pluck("id"), Classe.pluck("id") ).destroy_all
  end


  def self.chart_data(params)

    adozioni = aggregate_from_params params

    adozioni.map do |row|
      {
        label: row[0],
        value: row[1] || 0
      }
    end
  end




  def self.aggregate_from_params(params = {})

    query_params = {
      'row' => 'gruppo', 
      'value_name' => 'copie', 
      'materia_ids' => []
    }.merge(params)

    adozioni = scoped.joins(libro: :editore, classe: :cliente)

    unless query_params['materia_ids'].empty?
      adozioni = adozioni.where("libri.materia_id IN (?)", query_params['materia_ids'])
    end

    if query_params['row']

      if query_params['row'] == "gruppo"
        select_string = "editori.gruppo as row"
        group_string = "editori.gruppo"

      elsif query_params['row'] == "titolo" 
        select_string = "libri.titolo as row"
        group_string = "libri.titolo"

      elsif query_params['row'] == "editore" 
        select_string = "editori.nome as row"
        group_string = "editori.nome"

      elsif query_params['row'] == "scuola" 
        select_string = "clienti.titolo as row"
        group_string = "clienti.titolo"
        adozioni = adozioni.where("libri.settore = 'Scolastico'")
      end
    else
      select_string = "editori.gruppo as row"
      group_string = "editori.gruppo"
    end

    adozioni = adozioni.where("classi.anno = '2014'")
            
    adozioni = adozioni.select("#{select_string},  count(adozioni.id) as sezioni, sum(classi.nr_alunni) as copie, sum(libri.prezzo_copertina * classi.nr_alunni) as valore, sum(libri.prezzo_copertina * classi.nr_alunni * 0.25) as provvigioni")
    adozioni = adozioni.group(group_string)

    adozioni.each_with_object({}) do |adozione, values|
      values[adozione.row] = adozione.send(query_params['value_name']).to_f.round(2)
    end.sort_by{|k,v| v}.reverse
  end

  
  after_commit :update_cliente_properties
  
  
  private

    def update_cliente_properties
      classe.cliente.ricalcola_properties
    end


end
