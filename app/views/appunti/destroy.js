$("#<%= dom_id(@appunto) %>").slideUp('slow', function() {
	$(this).remove();
	var flash =	$('<div id="flash_notice">Appunto eliminato</div>');
	flash.prependTo("#top").delay(2000).slideUp("slow", function() {
		flash.remove();
	});
});