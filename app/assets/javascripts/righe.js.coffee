# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  $.validity.setup outputMode: 'summary'

  $('#new_libro.chzn-select').live 'change', () ->
    $('#new_libro_chzn').removeClass 'validity-erroneous chzn-container-active'
    $.getJSON "/libri/#{$(this).val()}",
      (libro) ->
        console.log(libro)
        $('#new_prezzo').val(libro.prezzo_copertina )
        $('#new_quantita').focus().select()
  
  $("#add-riga").live 'click', (e) ->
    e.preventDefault()
    
    $('#new_libro_chzn input').focus()
    $("#new_libro_chzn").addClass 'chzn-container-active'
    
    if validateRiga()

      titolo   =  $('#new_libro_chzn span').text()
      quantita =  $('#new_quantita').val()
      prezzo   =  $('#new_prezzo').val()
      sconto   =  $('#new_sconto').val()
      libro_id =  $('#create-riga .chzn-select').val()
      new_id  = new Date().getTime();

      if $("#righe").length == 0
        $('#create-riga').after("<div id='righe'></div>")
          
      new_riga = $("<div id='riga_#{new_id}' class='riga'></div>")
      $("#righe").append(new_riga)
      
      new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_libro_id' name='appunto[righe_attributes][new_#{new_id}][libro_id]' value='#{libro_id}' type='hidden'/>")
      new_riga.append("<div class='titolo'>#{titolo}</div>")
      new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_quantita' name='appunto[righe_attributes][new_#{new_id}][quantita]' value='#{quantita}' class='qta'/>")
      new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_prezzo'   name='appunto[righe_attributes][new_#{new_id}][prezzo]'   value='#{prezzo}' class='qta'/>")
      new_riga.append("<input id='appunto_righe_attributes_new_#{new_id}_sconto'   name='appunto[righe_attributes][new_#{new_id}][sconto]'   value='#{sconto}'   class='qta'/>")
      new_riga.append("<a href='javascript:void(0)' class='red_button remove_button'> - </a>")
      
      $("#new_libro_chzn").addClass 'chzn-container-active'
      

  $('.remove_button').live 'click', (e) ->
    e.preventDefault()
    $(this).parent().fadeOut 'normal', () ->
      $(this).remove()


validateRiga = () ->
  $.validity.start();
  $("#create-riga .chzn-select")
    .require("Seleziona il titolo!")
  $("#new_quantita")  
    .require()
    .match("integer")
  result = $.validity.end()
  unless result.valid
    $('#new_libro_chzn').addClass 'validity-erroneous'
  return result.valid




# <input id="appunto_appunto_righe_attributes_new_1323258827015_appunto_id" name="appunto[appunto_righe_attributes][new_1323258827015][appunto_id]" type="hidden"/>
# <select class="xxx-chzn-select-tax" id="appunto_appunto_righe_attributes_new_1323258827015_libro_id" name="appunto[appunto_righe_attributes][new_1323258827015][libro_id]">
# <label for="appunto_appunto_righe_attributes_new_1323258827015_quantita">Quantita</label>
# <input class="qta" id="appunto_appunto_righe_attributes_new_1323258827015_quantita" name="appunto[appunto_righe_attributes][new_1323258827015][quantita]" size="30" type="text"/>
# <label for="appunto_appunto_righe_attributes_new_1323258827015_price">Prezzo</label>
# <input class="qta" id="appunto_appunto_righe_attributes_new_1323258827015_price" name="appunto[appunto_righe_attributes][new_1323258827015][price]" size="30" type="text" value=""/>
# <input id="appunto_appunto_righe_attributes_new_1323258827015__destroy" name="appunto[appunto_righe_attributes][new_1323258827015][_destroy]" type="hidden" value="false"/>
# <a href="javascript:void(0)" class="btn_red remove_nested_fields">-</a>