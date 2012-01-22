jQuery ->
  $("[data-pjax-container]").bind 'pjax:end', () =>
    
    if $('#gmaps_page').length
      console.log 'pageshow'
      Gmaps.loadMaps()


    