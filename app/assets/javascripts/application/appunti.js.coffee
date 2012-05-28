# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  if $(".appunti").length > 0
    $(".appunti .appunto").each ->
      window.initializeAppunto($(@))
      
window.initializeAppunto = (appunto) ->

  $('time.timeago', appunto).timeago();
  
  # appunto.bind 'dblclick', (e) ->
  #   e.stopPropagation()
  #   e.preventDefault()
  #   $(@).toggleClass 'opened'

  $('.stato', appunto).bind 'click', (e) ->
    e.stopPropagation()
    $('.dropdown-toggle', appunto).dropdown().trigger 'click'

  $('a.change-status', appunto).bind 'click', (e) ->
    e.stopPropagation()
    id = $(@).data('id')
    stato = $(@).data('status')
    opened = appunto.hasClass('opened')
    console.log opened
    $.ajax 
      url: "/appunti/#{id}.json"  
      data: { appunto: { stato: stato } }
      type:  "PUT"
      success: (data)->
        $("#appunto_#{data.id}").replaceWith JST["appunti/appunto"](data)
        if opened
          $("#appunto_#{data.id}").toggleClass('opened')
          
        window.initializeAppunto($("#appunto_#{data.id}"))
        params = $("#appunti").data('json-url').split('?')[1] ||= ""
        $.get "/get_appunti_filters.js", params, (data) ->
          console.log "data"

  $('.show a', appunto).bind 'click', (e) ->
    e.stopPropagation()
    e.preventDefault()
    appunto = $(@).closest($('.appunto'))
    appunto.addClass('opened')
  
  $('.chiudi a', appunto).bind 'click', (e) ->
    e.stopPropagation()
    e.preventDefault()
    appunto = $(@).closest($('.appunto'))
    appunto.removeClass('opened')
    
  $('.edit a, .print a', appunto).bind 'click', (e) ->
    e.stopPropagation()

  # non funzia
  # $('.delete a', appunto).bind 'click', (e) ->
  # appunto = $(@).closest($('.appunto'))
  # appunto.addClass('opened')
  
  # $('.baule a', appunto).bind 'click', (e) ->
  #   e.stopPropagation()
  #   e.preventDefault()
  #   container = $(@).closest($('.appunto'))
  #   $(container).toggleClass 'favorited'
  # 
  #   appunto = 
  #     id: container.attr('id')
  #     cliente_titolo: $('.full_name', container).text()
  #     
  #   $('.side-right .well').append JST['appunti/baule'](appunto)



jQuery ->

  $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})

  @selected_appunti = []
  
  count_selected = (last_clicked) =>

    if last_clicked.hasClass('selected')
      @selected_appunti.push last_clicked.attr('id')
    else
      for item in @selected_appunti
        if item is last_clicked.attr('id')
          @selected_appunti.splice(@selected_appunti.indexOf(item), 1)
          
    $('#footer').html @selected_appunti.length 
    console.log @selected_appunti
    

  # $('.appunto').live 'click', (e) ->
  #   e.preventDefault()
  #   $(@).toggleClass("selected")
  #   pos = $('#appunti').scrollTop();
  #   count_selected $(@)
  #   #$('#footer').html $('.appunto.selected').length
  #   $('#appunti').scrollTop(pos);


  $('#new_appunto_button').live 'click', (e) ->

    e.preventDefault()
    $('#appunto_cliente_id_chzn').addClass('chzn-container-active');  
    $('#appunto_cliente_id_chzn input').focus();
    $('#appunti').scrollTop(pos)  
    
  $('#appunto_cliente_id.chzn-select').live 'change', () ->
    $.getJSON "/clienti/#{$('#appunto_cliente_id.chzn-select').val()}", (cliente) ->
      $('#ordine h3').html cliente.nome
      $('#appunto_cliente_id_chzn').removeClass 'validity-erroneous chzn-container-active'
      $('#appunto_destinatario').focus().select()
   

window.reset_appunto = ->
  console.log 'reset'
  $(".chzn-select").val('').trigger("liszt:updated");
  $("#appunto-small input[type=text], #appunto-small textarea").each ->
    $(@).val ''
  # $('#ordine .riga').remove()
  $('#ordine .empty').show()
  $('#new_quantita').val ''
  $('#new_prezzo').val ''
  $('#new_sconto').val ''
  $('#ordine h3').text ''
 


flash_notice = (message) ->
  flash =	$("<div id='flash_notice'>#{message}</div>")
  flash.prependTo("#top").delay(2000).slideUp "slow", () ->
    $(this).remove()

flash_error = (error) ->
  obj = JSON.parse(error)
  $.map obj, (val, i) ->
    title = $("<div id='error_explanation'><h2>impossibile salvare l'#{i}</h2><ul></ul></div>")
    title.prependTo(".form .field:first")
    $.map val['errors'], (v, index) ->
      errore = $("<li>il campo #{index} #{v[0]}</li>")
      errore.appendTo("#error_explanation ul")
