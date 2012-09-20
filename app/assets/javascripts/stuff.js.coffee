
jQuery ->
  
  $('.giunti-url').bind 'click', (e) ->
    e.preventDefault()
    $('#libro_remote_image_url').val "http://catalogo.giunti.it/librig/#{ $('#libro_cm').val()}.jpg"
  
  $(".fattura .show a").on 'click', (e) ->
    e.stopPropagation()
    e.preventDefault()
    $(@).closest($('.fattura')).addClass('opened')

  $('.fattura .chiudi a').on 'click', (e) ->
    e.stopPropagation()
    e.preventDefault()
    $(@).closest($('.fattura')).removeClass('opened')
      
  $('.the-modal .the-close').on 'click', (e) ->
    e.preventDefault()
    $.modal().close()
  
  $('.trigger').live 'click', (e) ->
    e.preventDefault();
    $('.the-modal').modal().open();
    