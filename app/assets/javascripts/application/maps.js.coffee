jQuery ->

  initialize_maps = ->
    if $('#gmaps_page').length
      console.log 'init maps events'
      Gmaps.map.HandleDragend = (pos) ->
        console.log pos
        $('#cliente_latitude').val pos.Ra
        $('#cliente_longitude').val pos.Sa

      Gmaps.map.callback = ->
        for marker in this.markers
          google.maps.event.addListener marker.serviceObject, 'dragend', ->
            Gmaps.map.HandleDragend this.getPosition()
      Gmaps.loadMaps()

    if $("#new_map").length
      
      map = new GMaps
        div: '#mappa'
        lat: -12.043333
        lng: -77.028333
      
      map.addMarker
        lat: -12.043333
        lng: -77.03
        title: 'Lima'
        details:
          database_id: 42
          author: 'HPNeo'
      
      map.addMarker
        lat: -12.042
        lng: -77.028333
        title: 'Marker with InfoWindow'
        infoWindow:
          content: '<p>HTML Content</p>'
  
  
  initialize_maps()    
