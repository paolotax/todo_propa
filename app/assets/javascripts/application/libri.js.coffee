jQuery ->
  
  $(".click-me").live 'click', (e) ->
    e.preventDefault();
    $.ajax 
      url: ''
      dataType: 'json'
      type:  "GET"
      success: (data)->
        $(".libro").replaceWith JST["libri/show"](data)
        console.log "data"