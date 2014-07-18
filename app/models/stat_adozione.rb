class StatAdozione < OpenStruct


  def self.aggregate_from_params(adozioni, params = {})

    query_params = {
      'row' => 'gruppo', 
      'value_name' => 'copie', 
      'materia_ids' => []
    }.merge(params)

    adozioni = adozioni.joins(libro: :editore, classe: :cliente)

    unless query_params['materia_ids'].empty?
      adozioni = adozioni.where("libri.materia_id IN (?)", query_params['materia_ids'])
    end

    if query_params['row'] == "gruppo"
      select_string = "editori.gruppo as row, clienti.provincia as column"
      group_string = "editori.gruppo, clienti.provincia"

    elsif query_params['row'] == "titolo" 
      select_string = "libri.titolo as row, clienti.provincia as column"
      group_string = "libri.titolo, clienti.provincia"

    elsif query_params['row'] == "editore" 
      select_string = "editori.nome as row, clienti.provincia as column"
      group_string = "editori.nome, clienti.provincia"

    elsif query_params['row'] == "scuola" 
      select_string = "clienti.titolo as row, clienti.provincia as column"
      group_string = "clienti.titolo, clienti.provincia"
      adozioni = adozioni.where("libri.settore = 'Scolastico'")
    end

    adozioni = adozioni.where("classi.anno = '2014'")
            
    adozioni = adozioni.select("#{select_string},  count(adozioni.id) as sezioni, sum(classi.nr_alunni) as copie, sum(libri.prezzo_copertina * classi.nr_alunni) as valore, sum(libri.prezzo_copertina * classi.nr_alunni * 0.25) as provvigioni")
    adozioni = adozioni.group("#{group_string}")


    grid =  StatAdozione.grouped_grid adozioni.all, query_params["value_name"]
    
    #grid.source_data.sort! {|a| a.value}.reverse
    
    grid

  end

  def self.grouped_grid( adozioni, value_name )
    result = []    
    adozioni.each do |adozione|

      result << StatAdozione.new( 
        row: adozione.row,
        value: adozione.try(value_name).to_f,
        column: adozione.column

      )
    end
    grid = StatAdozione.crea_grid result
  end

  
  def self.crea_grid(adozioni)
    
    grid = PivotTable::Grid.new do |g|
      g.source_data = adozioni
      g.column_name = :column
      g.row_name = :row
      g.value_name = :value
    end
    
    grid.build
  end

end