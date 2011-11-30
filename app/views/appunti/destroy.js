$("#<%= dom_id(@appunto) %>").slideUp('slow', function() {
	$(this).remove();
	var flash =	$('<div id="flash_notice">Appunto eliminato</div>');
	$(window).bind('scroll', function() {
		flash.css({	"top": $(window).scrollTop() });
	});
	flash.prependTo("#main").delay(1000).slideUp("slow");
});