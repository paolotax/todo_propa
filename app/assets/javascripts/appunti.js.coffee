# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  #$('.appunto a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.chzn-select').chosen()
  $('.appunto .stato').live 'click', (e) ->
    alert 'gino'
  $('#nuovo-appunto').live 'click', (e) ->
    e.preventDefault()
    $(this).fadeOut()
    $('#appunto-small').fadeIn('slow')
    $('#appunto_scuola_id_chzn input').focus();
    # $('#appunto_scuola_id_chzn input').css 'background-color': 'blue'
  
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
        $('#appunti').prepend Mustache.to_html($('#appunto_template').html(), response['appunto'])
        nuovoAppunto = $("#appunto_#{response['appunto']['id']}")
        nuovoAppunto.effect("highlight", {}, 3000)
        $('.on_the_spot_editing', nuovoAppunto).each initializeOnTheSpot
        $("#new_appunto")[0].reset();
        $(".chzn-select").val('').trigger("liszt:updated");
        flash =	$('<div id="flash_notice">Appunto inserito!</div>')
        flash.prependTo("#main").delay(2000).slideUp "slow", () ->
          $(this).remove()

flash_error = (error) ->
  obj = JSON.parse(error)
  $.map obj, (val, i) ->
    title = $("<div id='error_explanation'><h2>impossibile salvare l'#{i}</h2><ul></ul></div>")
    title.prependTo(".form .field:first")
    $.map val['errors'], (v, index) ->
      errore = $("<li>il campo #{index} #{v[0]}</li>")
      errore.appendTo("#error_explanation ul")
