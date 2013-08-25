# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  $.validity.setup outputMode: 'summary'

  $('button#modifica-prezzo').on "click", (e) ->
    e.preventDefault()
    console.log "modifica"
    if $('input#prezzo_consigliato').is ':checked'
      $(".input-mini.riga_prezzo").each ->
        prezzo = $(@).data('consigliato')
        sconto = 0.0
        $(@).val(prezzo.toFixed(2))
        $(@).siblings(".input-mini.riga_sconto").val sconto.toFixed(2)
    else if $('input#prezzo_con_sconto').is ':checked'
      $(".input-mini.riga_prezzo").each ->
        prezzo = $(@).data('copertina')
        sconto = parseFloat($("select#prezzo").val())
        $(@).siblings(".input-mini.riga_sconto").val sconto.toFixed(2)
        $(@).val(prezzo.toFixed(2))
  $("select#prezzo").on "change", () ->
    $('input#prezzo_con_sconto').attr('checked', true)


  # modifica automatica senza pulsante

  # $('input#prezzo_consigliato').on "change", () ->
  #   if $('input#prezzo_consigliato').is ':checked'
  #     $(".input-mini.riga_prezzo").each ->
  #       prezzo = $(@).data('consigliato')
  #       $(@).val(prezzo)
  #       $(@).siblings(".input-mini.riga_sconto").val 0.00
  
  # $('input#prezzo_con_sconto').on "change", () ->
  #   if $('input#prezzo_con_sconto').is ':checked'
  #     $(".input-mini.riga_prezzo").each ->
  #       prezzo = $(@).data('copertina')
  #       sconto = $("select#prezzo").val()
  #       $(@).siblings(".input-mini.riga_sconto").val sconto
  #       $(@).val(prezzo)

  # $("select#prezzo").on "change", () ->
  #   if $('input#prezzo_con_sconto').is ':checked'
  #     $(".input-mini.riga_sconto").each ->
  #       sconto = $("select#prezzo").val()
  #       $(@).val sconto

 
  $('#new_libro.chzn-select').bind 'change', () ->

    $('#new_libro_chzn').removeClass 'validity-erroneous chzn-container-active'
    
    $.getJSON "/libri/#{$(this).val()}", (libro) ->

      $('#new_copertina').val(parseFloat(libro["libro"].prezzo_copertina).toFixed(2))
      $('#new_consigliato').val(parseFloat(libro["libro"].prezzo_consigliato).toFixed(2))
      
      if $("#add-riga").hasClass('fattura')
        $('#new_prezzo').val(parseFloat(libro["libro"].prezzo_copertina).toFixed(2))
        $('#new_sconto').val 43.00.toFixed(2)
      else
        if $('input#prezzo_consigliato').is ':checked'
          $('#new_prezzo').val(parseFloat(libro["libro"].prezzo_consigliato).toFixed(2))
          $('#new_sconto').val 0.0.toFixed(2)
        else
          $('#new_prezzo').val(parseFloat(libro["libro"].prezzo_copertina).toFixed(2))
          $('#new_sconto').val parseFloat($('#prezzo').val()).toFixed(2)
        $('#new_quantita').focus().select()
  
  $(document).on "click", "#add-riga", (e) ->
    e.preventDefault()

    if $(@).hasClass('appunto')
      tipo = 'appunto'
    else
      tipo = 'fattura'

    if validateRiga()
      riga =
        titolo:   $('#new_libro_chzn span').text()
        quantita: $('#new_quantita').val()
        prezzo:   $('#new_prezzo').val()
        sconto:   $('#new_sconto').val()
        libro_id: $('#create-riga .chzn-select').val()
        copertina:   $('#new_copertina').val()
        consigliato: $('#new_consigliato').val()
        tipo: tipo

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
  
  console.log new_id 
  
  riga.id = new_id  
  
  new_riga = JST['righe/form'](riga)
  
  $("#righe").prepend(new_riga).fadeIn()
  # $(new_riga).stop().effect("highlight", {}, 1000)

  
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


