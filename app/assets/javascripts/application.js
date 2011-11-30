// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery.tools.min
//= require jquery_ujs
//= require chosen.jquery
//= require mustache
//= require jquery.pjax
//= require on_the_spot
//= require_tree .


$(document).ready(function() {
	$(".scrollable").scrollable({ vertical: true, mousewheel: true, circular: true });	
	
	$(".on_the_spot_editing").live( 'mouseout', function() {
		$(this).css('background-color', 'inherit');
	});
	$('.on_the_spot_editing').live('mouseover', function() {
		$(this).css('background-color', '#EEF2A0');
	});
	
	$('.note_markdown').live('click',function(event) {
		$(this).editable("update_attribute_on_the_spot", {
            type:       'textarea',
            cancel:     'Annulla',
            submit:     'OK',
            indicator:  '...',
            tooltip:    'Click to edit...',
            rows:       3,
            cols:       40,
            method:     "post",
            placeholder: "...",
            submitdata: {id: $(this).attr('id'), _method: "put" }

		});
	});
	
	// $('.on_the_spot_editing').live('click',function(event) {
	//     $(this).editable($(this).data('url'), {
	// 		  type:       'textarea',
	// 		  cancel:     'Annulla',
	// 		  submit:     'OK',
	// 		  indicator:  '...',
	// 		  tooltip:    'Click to edit...',
	// 		  rows:       $(this).data('rows'),
	// 			cols:   		$(this).data('columns'),
	// 		  method:     "post",
	// 		  placeholder: "...",
	// 		  submitdata: {id: $(this).attr('id'), value:$(this).attr('name'), _method: "put", authenticity_token: $(this).data('auth_token') }
	// 	 });
	// });

});


