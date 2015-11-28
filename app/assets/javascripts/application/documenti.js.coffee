jQuery ->
  
  $("#documento_causale_id").on 'change', (e) ->
    values = $(@).val().split(',')
    if values.length == 2
      
      $("#documento_numero").val values[1]
      console.log values[1]
      

  $(".remove-documento").live 'click', (e) ->
    e.preventDefault()
    riga = $(@).closest(".riga")
    riga_id = $(riga).attr("id").split("_")[1];
    
    $.ajax
      url: "/righe/#{riga_id}.json"  
      data: { riga: { remove_documento: true } }
      type:  "PUT"
      success: (data) ->
        $(riga).remove();