jQuery ->
  $("#classi_inserter_classe").live 'change', (e) ->
    $("label.checkbox input").attr('checked', false);
    $(".collection_checkbox label.checkbox").addClass("hidden")
    classe = $(@).val()
    if classe
      $(".insert-classi .more").removeClass("hidden")
    else
      $(".insert-classi .more").addClass("hidden")
          
    $("*[data-classe='#{classe}']").removeClass("hidden")