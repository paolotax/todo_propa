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
      $.getJSON "/scuole/#{$('#appunto_scuola_id.chzn-select').val()}", (scuola) ->
        $('#ordine h3').html scuola.nome
        $('#new_libro_chzn input').focus()
        $("#new_libro_chzn").addClass 'chzn-container-active'
  
  wizard.click ->
    wizard.expose
      color: '#789', 
      lazy: true

  $("button.next", wizard).click (e) ->
    e.preventDefault()
    if validateAppunto() is true
      myTabs = $("ul.tabs", wizard).data "tabs"
      myTabs.next()

validateAppunto = () ->
  $.validity.start();
  $("#appunto_scuola_id.chzn-select")
    .require("Seleziona il cliente!")
  result = $.validity.end()
  console.log "Validation result " + result
  unless result.valid
    $('#appunto_scuola_id_chzn').addClass 'validity-erroneous'
  return result.valid
  

			# $("ul.tabs", wizard).tabs("div.panes > div", function(event, index) {
			# 
			# 		/* now we are inside the onBeforeClick event */
			# 
			# 		// ensure that the "terms" checkbox is checked.
			# 		var terms = $("#terms");
			# 		if (index > 0 && !terms.get(0).checked)  {
			# 			terms.parent().addClass("error");
			# 
			# 			// when false is returned, the user cannot advance to the next tab
			# 			return false;
			# 		}
			# 
			# 		// everything is ok. remove possible red highlight from the terms
			# 		terms.parent().removeClass("error");
			# 	});
			# var api = $("ul.tabs", wizard).data("tabs");
			# 
			# 	// "next tab" button
			# 	$("button.next", wizard).click(function() {
			# 		api.next();
			# 	});
			# 
			# 	// "previous tab" button
			# 	$("button.prev", wizard).click(function() {
			# 		api.prev();
			# 	});