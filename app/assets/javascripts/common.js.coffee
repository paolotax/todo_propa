# testCallback = (object, value, settings) ->
#   converter = new Showdown.converter()
#   html = converter.makeHtml value
#   $(object).html html

jQuery ->

  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length

  $(".on_the_spot_editing, .note_mark").live 'mouseout', ->
    $(@).css 'background-color', 'inherit'
  
  $('.on_the_spot_editing, .note_mark').live 'mouseover', ->
    $(@).css 'background-color', '#EEF2A0'
  
  $(".search_options a").live 'click', (e) ->
    e.preventDefault()
    
    if !localStorage["pendingItems"]
      localStorage["pendingItems"] = JSON.stringify []
      
    $.retrieveJSON $(this).attr("href"), (data) ->
      pendingItems = $.parseJSON localStorage["pendingItems"]
      appunti = pendingItems.concat(data)
      $("#appunti").empty()
      for obj in appunti
        if obj.data?
          $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj.appunto)
        else
          $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj)       


    $('#appunti').empty()
