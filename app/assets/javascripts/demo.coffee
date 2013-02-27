jQuery ->
  $('#search-input').focus()

  render = (term, data, type) ->
    if type is "cliente"
      "<div class'cliente-item'>#{data.titolo} </br> #{data.citta}</div>"
    if type is "appunto"
      note = data.note
      if data.note.length > 150
        note = data.note.substring(0, 150) + "</br>(continua)"
      else
        note = data.note
     
      "<div class'appunto-item'>#{data.destinatario} </br> #{data.titolo} #{data.citta} </br><small>#{note}</small></div>"
    else
      term
  
  select = (term, data, type) ->
    document.location.href = document.location.origin + "/#{data.url}"
    
    # $("#result").html("<div><a href='#{data.url}'>#{term}</a></div>");
    # $("#search-input").val ""
    # $("ul#soulmate").hide()
    
  $('#search-query, #search-input').soulmate {
    url:            '/search/autocomplete.json'
    types:          ["cliente", "appunto", "libro"]
    renderCallback: render
    selectCallback: select
    minQueryLength: 2
    maxResults:     5
  }
  
  $('#main-search-input').soulmate {
    url:            '/search/autocomplete.json'
    types:          ["cliente", "appunto", "libro"]
    renderCallback: render
    selectCallback: select
    minQueryLength: 2
    maxResults:     5
  }