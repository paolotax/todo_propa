# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})
  
  @selected_appunti = []
  
  count_selected = (last_clicked) =>

    if last_clicked.hasClass('selected')
      @selected_appunti.push last_clicked.attr('id')
    else
      for item in @selected_appunti
        if item is last_clicked.attr('id')
          @selected_appunti.splice(@selected_appunti.indexOf(item), 1)
          
    $('#footer').html @selected_appunti.length 
    console.log @selected_appunti
    

  $('.appunto').live 'click', (e) ->
    e.preventDefault()
    $(@).toggleClass("selected")
    pos = $('#appunti').scrollTop();
    count_selected $(@)
    #$('#footer').html $('.appunto.selected').length
    $('#appunti').scrollTop(pos);

  $('.nascondi').live 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    $('#appunto-small').fadeOut()
    $('#nuovo-appunto').fadeIn('slow')
    $.mask.close()
    reset_appunto()

  
    
  $('.appunto .stato').live 'click', (e) ->
    alert 'gino'

  $('#btn-appunto').live 'click', (e) ->
    e.preventDefault()
    if validateAppunto()
      $.ajax
        data: $('#appunto-small > form').serialize()
        dataType: 'json'
        url: $('#appunto-small > form').attr 'action'
        type: $('#appunto-small > form').attr 'method'
        error: (xhr, status, error) ->
          flash_error xhr.responseText
        success: (response) ->
          $('#error_explanation').remove()
          # richiamo l'appunto inserito per avere i totali' da CORREGGERE
          id = response.id
          $.getJSON "appunti/#{id}.json",
            (appunto) ->
              $('.appunto_flash').replaceWith Mustache.to_html($('#appunto_tmp_template').html(), appunto)

              $("ul.tabs li").hide()
              $("ul.tabs").data("tabs").click(3)
               
              item =  $("#appunto_#{id}")
              if item.length
                item.replaceWith Mustache.to_html $('#appunto_template').html(), appunto
              else  
                $("#appunti").prepend Mustache.to_html $("#appunto_template").html(), appunto
 
              ri =  $("#appunto_#{id}")
              $('.on_the_spot_editing', ri ).each initializeOnTheSpot   
              ri.effect("highlight", {}, 3000)
              
              reset_appunto()
              
              # flash_notice "Appunto inserito!"


  $('#appunto_cliente_id.chzn-select').live 'change', () ->
    $.getJSON "/clienti/#{$('#appunto_cliente_id.chzn-select').val()}", (cliente) ->
      $('#ordine h3').html cliente.nome
      $('#appunto_cliente_id_chzn').removeClass 'validity-erroneous chzn-container-active'
      $('#appunto_destinatario').focus().select()
   

window.sbocci = ->
  alert "Sbocci!"

reset_appunto = ->
  console.log 'reset'
  $(".chzn-select").val('').trigger("liszt:updated");
  $("#appunto-small input[type=text], #appunto-small textarea").each ->
    $(@).val ''
  # $('#ordine .riga').remove()
  $('#ordine .empty').show()
  $('#new_quantita').val ''
  $('#new_prezzo').val ''
  $('#new_sconto').val ''
  $('#ordine h3').text ''
 
  # $('.nascondi').trigger 'click'


flash_notice = (message) ->
  flash =	$("<div id='flash_notice'>#{message}</div>")
  flash.prependTo("#top").delay(2000).slideUp "slow", () ->
    $(this).remove()

flash_error = (error) ->
  obj = JSON.parse(error)
  $.map obj, (val, i) ->
    title = $("<div id='error_explanation'><h2>impossibile salvare l'#{i}</h2><ul></ul></div>")
    title.prependTo(".form .field:first")
    $.map val['errors'], (v, index) ->
      errore = $("<li>il campo #{index} #{v[0]}</li>")
      errore.appendTo("#error_explanation ul")
