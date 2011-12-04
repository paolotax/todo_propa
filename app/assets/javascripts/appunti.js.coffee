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
    $(this).fadeOut('slow')
    $('#feedback').show()
    $('#appunto_scuola_id_chzn input').focus();
    $('#appunto_scuola_id_chzn input').css 'background-color': 'blue'