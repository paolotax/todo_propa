$(document).on 'page:change', ->
  $.datepicker.initialized = false

jQuery ->  
  console.log "ready" 
  $('#appunto_data_visita_text').datepicker
    dateFormat: 'dd-mm-yy'

window.validateAppunto = () ->
  $.validity.start();
  $("#appunto_cliente_id.chzn-select")
    .require("Seleziona il cliente!")
  $(".riga_quantita")
    .require()
    .match("integer")
  $(".riga_prezzo")
    .require()
    # .match("integer")
  result = $.validity.end()
  console.log "Validation result " + result
  unless result.valid
    $('#appunto_cliente_id_chzn').addClass 'validity-erroneous'
  return result.valid