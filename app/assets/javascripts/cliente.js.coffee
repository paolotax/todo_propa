jQuery ->
  window.comuni = $('#cliente_citta').html()

  $('#cliente_provincia').live 'change', ->
    provincia = $('#cliente_provincia :selected').text()
    escaped_provincia = provincia.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
    options = $(window.comuni).filter("optgroup[label='#{escaped_provincia}']").html()
    if options
      $('#cliente_citta').html(options)
      $('#cliente_citta').prepend("<option value></option>")
      $("#cliente_citta.chzn-select").trigger("liszt:updated");
    else
      $('#cliente_citta').empty()
    $('#cliente_indirizzi_attributes_0_provincia').val provincia
    
  $('#cliente_citta').live 'change', ->
    $('#cliente_indirizzi_attributes_0_citta').val $('#cliente_citta :selected').text()
  
  $('#cliente_provincia').trigger 'change'

  if $('.cliente .map').length
    @cliente = new Cliente()
  
  $("[data-pjax-container]").bind 'pjax:end', () =>
    window.comuni = $('#cliente_citta').html()
    $('#cliente_provincia').trigger 'change'
    if $('.cliente .map').length
      @cliente = new Cliente()
  
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
    
   
    
    