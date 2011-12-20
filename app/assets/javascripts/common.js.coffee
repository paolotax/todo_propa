jQuery ->
  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length

window.activateTabs = () ->
  wizard = $("#appunto-small")

  $("ul.tabs", wizard).tabs "div.panes > div", (event, index) ->
    allow = $('#appunto_scuola_id.chzn-select').val()
    console.log allow
    console.log allow == ""

    if index > 0 and allow == ""
      $('#appunto_scuola_id_chzn').addClass 'validity-erroneous'
      return false
    if index is 1 and validateAppunto() is true
        $('#new_libro_chzn input').focus()
        $("#new_libro_chzn").addClass 'chzn-container-active'
    if index is 2 and validateAppunto() is false
      return false
    
  wizard.click ->
    wizard.expose
      color: '#789', 
      lazy: true

  $("button.next", wizard).click (e) ->
    e.preventDefault()
    if validateAppunto() is true
      myTabs = $("ul.tabs", wizard).data "tabs"
      myTabs.next()
  $('#appunto_scuola_id.chzn-select').chosen();
  $('#new_libro.chzn-select').chosen();
  
  
window.validateAppunto = () ->
  $.validity.start();
  $("#appunto_scuola_id.chzn-select")
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
    $('#appunto_scuola_id_chzn').addClass 'validity-erroneous'
  return result.valid

