jQuery ->
  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  
  wizard = $("#appunto-small")

  $("ul.tabs", wizard).tabs "div.panes > div", (event, index) ->
    allow = $('#appunto_scuola_id.chzn-select').val()
    if index > 0 and allow == ""
      $('#appunto_scuola_id_chzn').addClass 'validity-erroneous'
      console.log allow
      return false
    if index == 1
      $('#new_libro_chzn input').focus()
      $("#new_libro_chzn").addClass 'chzn-container-active'
    $('#appunto_scuola_id_chzn').removeClass 'validity-erroneous'

  # non funziona
  myTabs = $("ul.tabs", wizard).data("tabs");

  $("button.next", wizard).click () ->
    myTabs.next()
	
  wizard.live 'click', () ->
    wizard.expose
      color: '#789', 
      lazy: true



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