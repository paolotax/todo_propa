
jQuery ->
  
  $('.giunti-url').bind 'click', (e) ->
    e.preventDefault()
    $('#libro_remote_image_url').val "http://catalogo.giunti.it/librig/#{ $('#libro_cm').val()}.jpg"
  
  $(".fattura").on 'click', (e) ->
    
    $(@).toggleClass('opened');    