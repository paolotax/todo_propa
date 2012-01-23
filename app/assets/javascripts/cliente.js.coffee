jQuery ->
  
  initialize_maps = ->
    if $('#gmaps_page').length
      
      Gmaps.map.HandleDragend = (pos) ->
        $('#cliente_indirizzi_attributes_0_latitude').val pos.Na
        $('#cliente_indirizzi_attributes_0_longitude').val pos.Oa

      Gmaps.map.callback = ->
        for marker in this.markers
          google.maps.event.addListener marker.serviceObject, 'dragend', ->
            Gmaps.map.HandleDragend this.getPosition()

      Gmaps.loadMaps()

  $("[data-pjax-container]").bind 'pjax:end', () ->
    initialize_maps()
    
  initialize_maps()    
    
    
    
      


    