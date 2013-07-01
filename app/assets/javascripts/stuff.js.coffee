jQuery ->
  
  $('.giunti-url').bind 'click', (e) ->
    e.preventDefault()
    $('#libro_remote_image_url').val "http://catalogo.giunti.it/librig/#{ $('#libro_cm').val()}.jpg"
      
  $('.the-modal .the-close').on 'click', (e) ->
    e.preventDefault()
    $.modal().close()
  
  $('.trigger').live 'click', (e) ->
    e.preventDefault();
    $('.the-modal').modal().open();
    