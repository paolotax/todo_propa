# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  #$('.appunto a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})
  $('.chzn-select-bis').chosen({no_results_text: "Nessuna corrispondenza trovata"})
	
  $('.nascondi').live 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    $('#appunto-small').fadeOut()
    $(".tabs > li:first a").trigger "click"
    $('#nuovo-appunto').fadeIn('slow')
    $.mask.close()
    reset_appunto()

  $('#nuovo-appunto').live 'click', (e) ->
    e.preventDefault()
    $(this).fadeOut()
    $('#appunto-small').fadeIn 'slow', () ->
      $('.nascondi').show()
    $('#appunto_scuola_id_chzn input').focus();
      
    $("#appunto-small").expose
      color: '#789', 
      lazy: true
    
    
  
  $('.appunto .stato').live 'click', (e) ->
    alert 'gino'

  $('#btn-appunto').live 'click', (e) ->
    e.preventDefault()
    $.ajax
      data: $('#new_appunto').serialize(),
      dataType: 'json',
      type: 'post',
      url: "/appunti",

      error: (xhr, status, error) ->
        flash_error xhr.responseText

      success: (response) ->
        $('#error_explanation').remove()

        # richiamo l'appunto inserito per avere i totali' da CORREGGERE
        id = response['appunto']['id']
        $.getJSON "appunti/#{id}.json",
          (appunto) ->
            console.log appunto
            $('#appunti').prepend Mustache.to_html($('#appunto_template').html(), appunto['appunto'])
            nuovoAppunto = $("#appunto_#{response['appunto']['id']}")
            nuovoAppunto.effect("highlight", {}, 3000)
            $('.on_the_spot_editing', nuovoAppunto).each initializeOnTheSpot
            flash_notice "Appunto inserito!"
            reset_appunto()

  $('#appunto_scuola_id.chzn-select').live 'change', () ->
    nomeScuola = $('#appunto_scuola_id_chzn a span').text()
    $('#ordine h3').html nomeScuola
    $.getJSON "/scuole/#{$(this).val()}",
      (scuola) ->
        console.log scuola


    

flash_notice = (message) ->
  flash =	$("<div id='flash_notice'>#{message}</div>")
  flash.prependTo("#top").delay(2000).slideUp "slow", () ->
    $(this).remove()
  

reset_appunto = () ->
  $(".chzn-select").val('').trigger("liszt:updated");
  $("#new_appunto")[0].reset()
  $('#righe .riga:first-child').show()
  $('#new_quantita').val ''
  $('#new_prezzo').val ''
  $('#new_sconto').val ''
  $('#ordine h3').text ''
  $("ul.tabs").data("tabs").click(0)
  # $('.nascondi').trigger 'click'


flash_error = (error) ->
  obj = JSON.parse(error)
  $.map obj, (val, i) ->
    title = $("<div id='error_explanation'><h2>impossibile salvare l'#{i}</h2><ul></ul></div>")
    title.prependTo(".form .field:first")
    $.map val['errors'], (v, index) ->
      errore = $("<li>il campo #{index} #{v[0]}</li>")
      errore.appendTo("#error_explanation ul")
