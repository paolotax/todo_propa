jQuery ->
  
  initialize_maps = ->
    if $('#gmaps_page').length
      
      console.log 'init maps events'
      
      Gmaps.map.HandleDragend = (pos) ->
        $('#cliente_latitude').val pos.Na
        $('#cliente_longitude').val pos.Oa

      Gmaps.map.callback = ->
        for marker in this.markers
          google.maps.event.addListener marker.serviceObject, 'dragend', ->
            Gmaps.map.HandleDragend this.getPosition()

      Gmaps.loadMaps()
    
  initialize_maps()    
    
    
    
      


    