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
        $(riga).remove();
  
  
  $('.show-fattura a.apri-fattura').live 'click', (e) ->
    e.stopPropagation()
    e.preventDefault()
    fattura = $(@).closest(".fattura")
    id = fattura.data("id")
    $.ajax 
      url: "/fatture/#{id}"  
      dataType: 'json'
      success: (data) ->
        fattura.replaceWith JST["fatture/fattura"](data)
        $("#fattura_#{data.id}").toggleClass('opened')
        
  
    
    
    