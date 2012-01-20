class Cliente

  constructor: () ->

    clienti = []
    $('.cliente').each ->
      clienti.push
        html:
          content: $('.cliente .nome').text()
          popup: true        

    mappa = $(".map").goMap
      latitude:  $('.cliente').data('latitude') + 0.001
      longitude: $('.cliente').data('longitude')
      maptype:   'ROADMAP'
      zoom: 13
    
    overlay = $.goMap.overlay
    
    setTimeout ->
      $.goMap.createMarker
        latitude:  $('.cliente').data('latitude')
        longitude: $('.cliente').data('longitude')
        title:     $('.cliente .nome').text()
      
      $($.goMap.markers).each (i, marker) ->
        $.goMap.createListener
          type:'marker' 
          marker: marker
          , 'click', ->
            displayPoint(marker, i)
      
      $("#message").appendTo(overlay.getPanes().floatPane)
      
      displayPoint = (marker, index) ->
        $("#message").attr('mId', marker)
        $("#message").hide()
        
        position = $($.goMap.mapId).data(marker).position
        title    = $($.goMap.mapId).data(marker).title
        
        moveEnd = $.goMap.createListener 
          type: 'map'
          , 'bounds_changed'
          , () ->
            markerOffset = overlay.getProjection().fromLatLngToDivPixel(position)
            $("#message").text title
            $("#message")
              .fadeIn()
              .css({ top:markerOffset.y, left:markerOffset.x });

            if($("#message").attr('mId') != marker)
              $.goMap.removeListener(moveEnd);
        $.goMap.map.panTo(position);
    , 500    
    
    $("#message").live 'click', ->
      $(@).hide()
    
   
    
    