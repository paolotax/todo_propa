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
  
  $(".search_options a, .filters a").live 'click', (e) ->
    e.preventDefault()
    
    if !localStorage["pendingItems"]
      localStorage["pendingItems"] = JSON.stringify []
    
    params = $(@).attr('href').split('?')[1] ||= ""
    console.log params
    
    $.getJSON $(@).attr('href'), (data) ->
      pendingItems = $.parseJSON localStorage["pendingItems"]
      appunti = pendingItems.concat(data)
      $("#appunti").empty()
      for obj in appunti
        if obj.data?
          $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj.appunto)
        else
          $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj)     
      
      $.get "\get_appunti_filters.js", params, (data) ->
        console.log "data"

    $('#appunti').empty()
