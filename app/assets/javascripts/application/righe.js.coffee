# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  $.validity.setup outputMode: 'summary'

  $('#new_libro.chzn-select').live 'change', () ->
    console.log 'change'
    $('#new_libro_chzn').removeClass 'validity-erroneous chzn-container-active'
    $.getJSON "/libri/#{$(this).val()}", 
      (libro) ->
        if $('input#prezzo_consigliato').is ':checked'
          $('#new_prezzo').val(libro.prezzo_consigliato)
        else
          $('#new_prezzo').val(libro.prezzo_copertina)
          $('#new_sconto').val $('#prezzo').val()
        $('#new_quantita').focus().select()
  
  $("#add-riga").live 'click', (e) ->
    e.preventDefault()
    if validateRiga()
      riga =
        titolo:   $('#new_libro_chzn span').text()
        quantita: $('#new_quantita').val()
        prezzo:   $('#new_prezzo').val()
        sconto:   $('#new_sconto').val()
        libro_id: $('#create-riga .chzn-select').val()
      
      $('.empty').hide()
      
      appendRiga riga
      $('#new_libro_chzn input').focus()
      $("#new_libro_chzn").addClass 'chzn-container-active'
      
  $('.remove_button').live 'click', (e) ->
    e.preventDefault()
    $(@).parent().fadeOut 'normal', () ->
      $(@).remove()
      $('.empty').fadeIn() if  $('#ordine .riga').length == 0



appendRiga = (riga) ->
  new_id   = new Date().getTime()
  if $("#righe").length == 0
    $('#create-riga').after("<div id='righe'></div>")
  new_riga = $("<div id='riga_#{new_id}' class='riga'></div>")
  new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_libro_id' name='appunto[righe_attributes][new_#{new_id}][libro_id]' value='#{riga.libro_id}' type='hidden'/>")
  new_riga.append("<div class='titolo'>#{riga.titolo}</div>")
  new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_quantita' name='appunto[righe_attributes][new_#{new_id}][quantita]' value='#{riga.quantita}' class='riga_quantita qta'/>")
  new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_prezzo'   name='appunto[righe_attributes][new_#{new_id}][prezzo]'   value='#{riga.prezzo}'   class='qta riga_prezzo'/>")
  new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_sconto'   name='appunto[righe_attributes][new_#{new_id}][sconto]'   value='#{riga.sconto}'   class='qta riga_sconto'/>")
  new_riga.append("<a href='javascript:void(0)' class='red_button remove_button'> - </a>")
  $("#righe").prepend(new_riga).fadeIn()
  new_riga.stop().effect("highlight", {}, 1000)

  
window.validateRiga = () ->
  $.validity.start();
  $("#create-riga .chzn-select")
    .require("Seleziona il titolo!")
  $("#new_quantita")  
    .require()
    .match("integer")
  result = $.validity.end()
  unless result.valid
    $('#new_libro_chzn').addClass 'validity-erroneous'
  return result.valid


