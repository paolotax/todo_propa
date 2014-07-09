jQuery ->
  
  $("#classi_inserter_classe").live 'change', (e) ->
    
    $(".row[data-classe]").addClass("hidden")    
    $(".collection_checkbox label.checkbox").addClass("hidden")
    $("label.checkbox input").attr('checked', false);
    
    classe = $(@).val()
    if classe
      $(".insert-classi .more").removeClass("hidden")
      $("*[data-classe='#{classe}']").removeClass("hidden")
    else
      $(".insert-classi .more").addClass("hidden")
    
    
  

  $("#new_classi_inserter input[type=checkbox").live 'change', (e) ->

    clicked = $(@)
    materiaSpan = $(@).parent().parent()
    
    $("input[type=checkbox", materiaSpan).each ->
      if $(@).val() != clicked.val()
        $(@).attr('checked', false);
