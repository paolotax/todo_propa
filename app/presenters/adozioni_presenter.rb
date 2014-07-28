class AdozioniPresenter


  def initialize(scope, params={})

    @query = scope

    @group_params = ActiveSupport::HashWithIndifferentAccess.new({
      row: 'gruppo', 
      column: 'provincia',
      value_name: 'copie', 
      materia_ids: []
    }).merge(params)

  end


  def chart_data
    aggregate_from_params.map do |row|
      {
        label: row[0],
        value: row[1] || 0
      }
    end
  end


  def grid

    grid = PivotTable::Grid.new do |g|
      g.source_data = aggregate_for_grid
      g.column_name = :column
      g.row_name = :row
      g.value_name = :value
    end
    
    grid.build
  end


  private


  def aggregate_from_params

    adozioni = @query.joins(libro: [:editore, :materia], classe: :cliente)


    if @group_params[:row] == "gruppo"
      select_string = "editori.gruppo as row"
      group_string = "editori.gruppo"

    elsif @group_params[:row] == "titolo" 
      select_string = "libri.titolo as row"
      group_string = "libri.titolo"

    elsif @group_params[:row] == "editore" 
      select_string = "editori.nome as row"
      group_string = "editori.nome"

    elsif @group_params[:row] == "scuola" 
      select_string = "clienti.titolo as row"
      group_string = "clienti.titolo"
      adozioni = adozioni.where("libri.settore = 'Scolastico'")
    end


    adozioni = adozioni.where("classi.anno = '2014'")
            
    adozioni = adozioni.select("#{select_string},  count(adozioni.id) as sezioni, sum(classi.nr_alunni) as copie, sum(libri.prezzo_copertina * classi.nr_alunni) as valore, sum(libri.prezzo_copertina * classi.nr_alunni * 0.25) as provvigioni")
    adozioni = adozioni.group(group_string)

    # raise adozioni.to_sql.inspect
    
    adozioni.each_with_object({}) do |adozione, values|
      values[adozione.row] = adozione.send(@group_params[:value_name]).to_f.round(2)
    end.sort_by{|k,v| v}.reverse

  end


  def aggregate_for_grid

    adozioni = @query.joins(libro: [:editore, :materia], classe: :cliente)

    if @group_params[:row] == "gruppo"
      
      group_string = "editori.gruppo"

    elsif @group_params[:row] == "titolo" 
      
      group_string = "libri.titolo"

    elsif @group_params[:row] == "editore" 
      
      group_string = "editori.nome"

    elsif @group_params[:row] == "scuola" 
      
      group_string = "clienti.titolo"
      adozioni = adozioni.where("libri.settore = 'Scolastico'")
    end

    
    if @group_params[:column] == "provincia"
      column_string = "clienti.provincia"
      
    elsif @group_params[:column] == "materia" 
      column_string = "materie.materia"
      
    elsif @group_params[:column] == "titolo" 
      column_string = "libri.titolo"
      adozioni = adozioni.where("libri.settore = 'Scolastico'")

    end


    adozioni = adozioni.where("classi.anno = '2014'")
            
    adozioni = adozioni.select("#{group_string} as row, #{column_string} as column, count(adozioni.id) as sezioni, sum(classi.nr_alunni) as copie, sum(libri.prezzo_copertina * classi.nr_alunni) as valore, sum(libri.prezzo_copertina * classi.nr_alunni * 0.25) as provvigioni")
    adozioni = adozioni.group("#{group_string}, #{column_string}")

    data = []
    adozioni.each do |adozione|
      data << OpenStruct.new(
        row: adozione.row,
        value: adozione.try(@group_params[:value_name]).to_f,
        column: adozione.column
      )
    end
    data

  end

end
