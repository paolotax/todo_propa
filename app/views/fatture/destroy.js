$("#<%= dom_id(@fattura) %>").fadeOut('slow', function() {
	$(this).remove();
	var flash =	$('<div id="flash_notice">Documento eliminato</div>');
	flash.prependTo("#top").delay(2000).slideUp("slow", function() {
		flash.remove();
	});
});