jQuery ->
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
            $("#appunti").append JST['appunti/appunto'](obj.appunto)
          else
            $("#appunti").append JST['appunti/appunto'](obj)       
        
        $('time.timeago').timeago();
        
        $('.actions .baule a').bind 'click', (e) ->
          e.preventDefault()
          console.log 'baule'
          container = $(@).parent().parent().parent().parent().parent()
          appunto = 
              id: container.attr('id')
              cliente_titolo: $('.full_name', container).text()
          $('.side-right .well').append JST['appunti/baule'](appunto)


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