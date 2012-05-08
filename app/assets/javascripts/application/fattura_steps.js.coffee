# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  
  $(".remove-fattura").on 'click', (e) ->
    e.preventDefault()
    riga = $(@).closest(".riga")
    riga_id = $(riga).attr("id").split("_")[1];
    
    $.ajax
      url: "/righe/#{riga_id}.json"  
      data: { riga: { remove_fattura: true } }
      type:  "PUT"
      
      success: (data) ->
        console.log "succ"
        $(riga).remove();
    
    
    