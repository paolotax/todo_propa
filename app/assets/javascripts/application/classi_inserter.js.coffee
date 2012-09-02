jQuery ->
  $("#classi_inserter_classe").live 'change', (e) ->
    $("label.checkbox input").attr('checked', false);
    $(".collection_checkbox label.checkbox").addClass("hidden")
    classe = $(@).val()
    if classe
      $(".more").removeClass("hidden")
    else
      $(".more").addClass("hidden")
          
    $("*[data-classe='#{classe}']").removeClass("hidden")