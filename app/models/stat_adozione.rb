class StatAdozione < OpenStruct


  def self.aggregate_from_params(params)

    adozioni = Adozione.joins(libro: :editore, classe: :cliente).where("clienti.user_id = ?", params[:user_id])

    unless params["materia_ids"].empty?
      adozioni = adozioni.where("libri.materia_id IN (?)", params["materia_ids"])
    end

    if params["row"]

      if params["row"] == "gruppo"
        select_string = "editori.gruppo as row, clienti.provincia as column"
        group_string = "editori.gruppo, clienti.provincia"

      elsif params["row"] == "titolo" 
        select_string = "libri.titolo as row, clienti.provincia as column"
        group_string = "libri.titolo, clienti.provincia"

      elsif params["row"] == "editore" 
        select_string = "editori.nome as row, clienti.provincia as column"
        group_string = "editori.nome, clienti.provincia"

      end
    else
      select_string = "editori.gruppo as row, clienti.provincia as column"
      group_string = "editori.gruppo, clienti.provincia"
    end

    adozioni = adozioni.where("classi.anno = '2014'")
            
    adozioni = adozioni.select("#{select_string},  count(adozioni.id) as sezioni, sum(classi.nr_alunni) as copie, sum(libri.prezzo_copertina * classi.nr_alunni) as valore, sum(libri.prezzo_copertina * classi.nr_alunni * 0.25) as provvigioni")
    adozioni = adozioni.group("#{group_string}")

    #raise adozioni.all.size.inspect

    grid =  StatAdozione.grouped_grid adozioni.all, params["value_name"]
    

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