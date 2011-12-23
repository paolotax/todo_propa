class App.Libro extends Spine.Model
  @configure 'Libro', 'titolo', 'cm', 'prezzo_copertina', 'prezzo_consigliato', 'type', 'image', 'remote_image_url', 'materia_id'
  @extend Spine.Model.Ajax

  @url: "/libri"
  
  @titoloSort: (a,b) ->
    #console.log a.titolo, b.titolo
    if a.titolo is b.titolo 
      return 0
    if a.titolo < b.titolo 
      return -1 
    else 
      return 1

  @filter: (query, field="type") ->
    return @all() unless query
    query = query.toLowerCase()

    @select (item) ->
      if field?
        item[field]?.toLowerCase() is query
      else
        item[field]?.toLowerCase().indexOf(query) isnt -1 or
          item[field]?.toLowerCase().indexOf(query) isnt -1