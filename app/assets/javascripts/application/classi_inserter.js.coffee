jQuery ->
  $("#classi_inserter_classe").change (e) ->
    $(".collection_checkbox label.checkbox").addClass("hidden")
    classe = $(@).val()
    if classe
      $(".more").removeClass("hidden")
    else
      $(".more").addClass("hidden")
          
    $("*[data-classe='#{classe}']").removeClass("hidden")