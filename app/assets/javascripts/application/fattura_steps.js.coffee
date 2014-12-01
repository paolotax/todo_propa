jQuery ->
  
  $("#fattura_causale").on 'change', (e) ->
    values = $(@).val().split(',')
    if values.length == 2
      $("#fattura_numero").val values[1]
      



  $(".remove-fattura").live 'click', (e) ->
    e.preventDefault()
    riga = $(@).closest(".riga")
    riga_id = $(riga).attr("id").split("_")[1];
    
    $.ajax
      url: "/righe/#{riga_id}.json"  
      data: { riga: { remove_fattura: true } }
      type:  "PUT"
      success: (data) ->
        $(riga).remove();
  

  # chiama fattura show json
  
  # $('.show-fattura a.apri-fattura').live 'click', (e) ->
  #   e.stopPropagation()
  #   e.preventDefault()
  #   fattura = $(@).closest(".fattura")
  #   id = fattura.data("id")
  #   $.ajax 
  #     url: "/fatture/#{id}"  
  #     dataType: 'json'
  #     success: (data) ->
  #       fattura.replaceWith JST["fatture/fattura"](data["fattura"])
  #       fattura = $("#fattura_#{data['fattura'].id}")
  #       fattura.toggleClass('opened')
  #       if fattura.data("pagata") == true
  #         fattura.removeClass("da_pagare")
  #       else
  #         fattura.addClass("da_pagare")        
  
  # $('.fattura .chiudi a').live 'click', (e) ->
  #   e.stopPropagation()
  #   e.preventDefault()
  #   fattura = $(@).closest($('.fattura'))
  #   fattura.removeClass('opened')
  #   if fattura.data("pagata") == true
  #     fattura.removeClass("da_pagare")
  #   else
  #     fattura.addClass("da_pagare")


    