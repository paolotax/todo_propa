# testCallback = (object, value, settings) ->
#   converter = new Showdown.converter()
#   html = converter.makeHtml value
#   $(object).html html

jQuery ->
  $('.pjax, .pjax a').pjax('[data-pjax-container]', { timeout: 10000 })

  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length

  $(".on_the_spot_editing, .note_mark").live 'mouseout', ->
    $(@).css 'background-color', 'inherit'
  
  $('.on_the_spot_editing, .note_mark').live 'mouseover', ->
    $(@).css 'background-color', '#EEF2A0'
