jQuery ->
  
  #  DEPRECATED lista adozioni

  # $("#classi_inserter_classe").live 'change', (e) ->
    
  #   $(".row[data-classe]").addClass("hidden")    
  #   $(".collection_checkbox label.checkbox").addClass("hidden")
  #   $("label.checkbox input").attr('checked', false);
    
  #   classe = $(@).val()
  #   if classe
  #     $(".insert-classi .more").removeClass("hidden")
  #     $("*[data-classe='#{classe}']").removeClass("hidden")
  #   else
  #     $(".insert-classi .more").addClass("hidden")
  
  # $(".chzn-adozioni-input").chosen()  
    
  

  # $("#new_classi_inserter input[type=checkbox").live 'change', (e) ->

  #   clicked = $(@)
  #   materiaSpan = $(@).parent().parent()
    
  #   $("input[type=checkbox", materiaSpan).each ->
  #     if $(@).val() != clicked.val()
  #       $(@).attr('checked', false);



  $(".chzn-adozioni-input").chosen()
  
  initialize_libri = ->
      if $('#classi_inserter_libro_ids').length
        lista_libri = new ListLibri()
        
    initialize_libri()

class ListLibri
  
  constructor: () ->
    @list_classe    = $('#classi_inserter_classe')
    @list_libri     = $('#classi_inserter_libro_ids')

    @classe = $(':selected', @list_classe).text()
    @list_classe.live 'change', @change

  get_libri: () =>
    $.getJSON "/libri.json", { 'adottabile_per_classe': @classe }, @render

  render: (objs) =>
    @list_libri.empty().append("<option></option")
    @libri = objs

    for c in @libri
      @list_libri.append("<option value='#{c["libro"].id}'>#{c["libro"].titolo}</option")
    @list_libri.trigger("liszt:updated")

  change: () =>
    @classe = $(':selected', @list_classe).text()
    @get_libri()


