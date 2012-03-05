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
            $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj.appunto)
          else
            $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj)       


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
            $("#clienti").append Mustache.to_html($("#cliente_template").html(), obj.cliente)
          else
            $("#clienti").append Mustache.to_html($("#cliente_template").html(), obj)


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
  
      $("#appunti").prepend Mustache.to_html($("#appunto_template").html(), item.appunto)
      pendingItems.push(item);
      localStorage["pendingItems"] = JSON.stringify(pendingItems)
      sendPending();
      e.preventDefault();

      window.reset_appunto()

    sendPending = ->
      if window.navigator.onLine
        pendingItems = $.parseJSON localStorage["pendingItems"]
        if pendingItems.length > 0
          item = pendingItems[0]
          $.post "/appunti.json", item.data, (data) ->
            pendingItems = $.parseJSON localStorage["pendingItems"]
            pendingItems.shift()
            localStorage["pendingItems"] = JSON.stringify(pendingItems)
            console.log data
            $("#appunto_#{item.appunto.id}").replaceWith( Mustache.to_html($("#appunto_template").html(), data))            
            setTimeout(sendPending, 100)

    sendPending()

    $(window).bind "online", sendPending

  else
    alert "Try a different browser."