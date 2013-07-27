# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  $(document).on "click", ".appunto.item", (e) ->
    e.stopPropagation()
    $(@).toggleClass('opened')

  # $(document).on 'touchstart' , ".appunto.item", (e) ->
  #   e.stopPropagation()
  #   console.log 'touchstart'
  #   $(@).toggleClass('opened')
  
  $(document).on "click", ".appunto.item input[type='checkbox'], .appunto.item a, .appunto-item button, .nav-actions li a, .nav-actions li button", (e) ->
    e.stopPropagation()

  $(document).on "touchstart", ".appunto.item input[type='checkbox'], .appunto.item a, .appunto-item button, .nav-actions li a, .nav-actions li button", (e) ->
    e.stopPropagation()
  
  $(document).on "click", ".item .show a", (e) ->
    e.stopPropagation()
    e.preventDefault()
    item = $(@).closest($('.item'))
    item.addClass('opened')
  
  $(document).on "click", '.item .chiudi a', (e) ->
    e.stopPropagation()
    e.preventDefault()
    item = $(@).closest($('.item'))
    item.removeClass('opened')

  $(document).on "click", 'a.change-status', (e) ->
    e.stopPropagation()
    e.preventDefault()
    appunto = $(@).closest($('.appunto'))
    id = $(@).data('id')
    stato = $(@).data('status')
    $.ajax 
      url: "/appunti/#{id}"  
      data: { appunto: { stato: stato } }
      type:  "PUT"
      dataType: "script"

  
  $('time.timeago').timeago();


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
    
  $('#new_appunto_button').live 'click', (e) ->
    e.preventDefault()
    $('#appunto_cliente_id_chzn').addClass('chzn-container-active');  
    $('#appunto_cliente_id_chzn input').focus();
    $('#appunti').scrollTop(pos)  
    
  $('#appunto_cliente_id.chzn-select').live 'change', () ->
    $.getJSON "/clienti/#{$('#appunto_cliente_id.chzn-select').val()}.json", (cliente) ->
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
