jQuery ->
  
  initializeAppunto = (appunto) ->

    $('time.timeago', appunto).timeago();
    
    appunto.bind 'click', (e) ->
      $(@).toggleClass 'opened'

    $('.stato', appunto).bind 'click', (e) ->
      e.stopPropagation()
      $('.dropdown-toggle', appunto).dropdown().trigger 'click'

    $('a.change-status', appunto).bind 'click', (e) ->
      e.stopPropagation()
      id = $(@).data('id')
      stato = $(@).data('status')
      $.ajax 
        url: "/appunti/#{id}.json"  
        data: { appunto: { stato: stato } }
        type:  "PUT"
        success: (data)->
          $("#appunto_#{data.id}").replaceWith JST["appunti/appunto"](data)
          initializeAppunto($("#appunto_#{data.id}"))
          params = $("#appunti").data('json-url').split('?')[1] ||= ""
          $.get "/get_appunti_filters.js", params, (data) ->
            console.log "data"

    $('.show a', appunto).bind 'click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      appunto = $(@).closest($('.appunto'))
      appunto.addClass('opened')
    
    $('.chiudi a', appunto).bind 'click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      appunto = $(@).closest($('.appunto'))
      appunto.removeClass('opened')
      
    $('.edit a, .print a', appunto).bind 'click', (e) ->
      e.stopPropagation()

    # non funzia
    # $('.delete a', appunto).bind 'click', (e) ->
    # appunto = $(@).closest($('.appunto'))
    # appunto.addClass('opened')
    
    $('.baule a', appunto).bind 'click', (e) ->
      e.stopPropagation()
      e.preventDefault()
      container = $(@).closest($('.appunto'))
      $(container).toggleClass 'favorited'

      appunto = 
          id: container.attr('id')
          cliente_titolo: $('.full_name', container).text()

      $('.side-right .well').append JST['appunti/baule'](appunto)

  if $.support.localStorage
    $(window.applicationCache).bind "error", () ->
      console.log("Errore nel caricamento del cache manifest file.");
    
    if !localStorage["pendingAppunti"]
      localStorage["pendingAppunti"] = JSON.stringify []


    if $('#appunti').length
      $.retrieveJSON "/appunti.json" + window.location.search, (data) ->
        pendingAppunti = $.parseJSON localStorage["pendingAppunti"]
        appunti = pendingAppunti.concat(data)
        
        $("#appunti").empty()
        for obj in appunti
          if obj.data?
            appunto = JST['appunti/appunto'](obj.appunto)
            $("#appunti").append appunto
          else
            appunto = JST['appunti/appunto'](obj)
            $("#appunti").append appunto
          
          initializeAppunto($(".appunto:last-child"))
            
            


    if !localStorage["pendingClienti"]
      localStorage["pendingClienti"] = JSON.stringify []
    
    if $('#clienti').length
      $.retrieveJSON "/clienti.json" + window.location.search, (data) ->
        console.log "retrieve"
        pendingClienti = $.parseJSON localStorage["pendingClienti"]
        clienti = pendingClienti.concat(data)
        $("#clienti").empty()
        for obj in clienti
          if obj.data?
            $("#clienti").append JST['clienti/cliente'](obj.cliente)
          else
            $("#clienti").append JST['clienti/cliente'](obj)


    $("#new_appunto_submit").live 'click', (e) ->
      pendingAppunti = $.parseJSON localStorage["pendingAppunti"];
      item = 
        "data": $("#new_appunto").serialize()
        "appunto": 
          "cliente_id":   $("#appunto_cliente_id").val()
          "cliente_nome": $("#appunto_cliente_id_chzn a span").text()
          "id":           "pending_#{new Date().getTime()}"
          "destinatario": $("#appunto_destinatario").val()
          "note":         $("#appunto_note").val()
          "telefono":     $("#appunto_telefono").val()
          "email":        $("#appunto_email").val()
          "stato":        "pending"
          "con_recapiti": true
          "con_righe":    false
      
      $("#appunti").prepend JST['appunti/appunto'](item.appunto)
      pendingItems.push(item);
      localStorage["pendingItems"] = JSON.stringify(pendingItems)
      sendPending();
      e.preventDefault();
    
      window.reset_appunto()

    sendPending = ->
      console.log('send pending')
      if window.navigator.onLine
        pendingAppunti = $.parseJSON localStorage["pendingAppunti"]
        if pendingAppunti.length > 0
          item = pendingAppunti[0]
          $.post "/appunti.json", item.data, (data) ->
            pendingAppunti = $.parseJSON localStorage["pendingAppunti"]
            pendingAppunti.shift()
            localStorage["pendingAppunti"] = JSON.stringify(pendingAppunti)
            console.log data
            $("#appunto_#{item.appunto.id}").replaceWith JST['appunti/appunto'](data)             
            $('time.timeago').timeago();
            setTimeout(sendPending, 100)

    sendPending()

    $(window).bind "online", sendPending

  else
    alert "Try a different browser."