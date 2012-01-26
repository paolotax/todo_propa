jQuery ->
  $('.pjax a').pjax('[data-pjax-container]', { timeout: 10000 })

  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length

  testCallback = (object, value, settings) ->
    converter = new Showdown.converter()
    html = converter.makeHtml value
    $(object).html html

  $(".scrollable").scrollable
    vertical: true
    mousewheel: true
    circular: true

  $(".on_the_spot_editing, .note_mark").live 'mouseout', ->
    $(@).css 'background-color', 'inherit'

  $('.on_the_spot_editing, .note_mark').live 'mouseover', ->
    $(this).css 'background-color', '#EEF2A0'
