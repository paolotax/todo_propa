jQuery ->
  
  initialize_maps = ->
    if $('#gmaps_page').length
      Gmaps.loadMaps()
  
  $("[data-pjax-container]").bind 'pjax:end', () ->
    initialize_maps()
    
  initialize_maps()    
    
    
    
      


    