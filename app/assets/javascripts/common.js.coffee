jQuery ->
  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length
  
  # $("#nuovo-appunto").click ->
  #   console.log "CIAO"
  #   miaform = new AppuntoForm $("#appunto-small")
  # 
  # $('.search_options h2').click ->
  #   alert "gino"
  #   miaform = new AppuntoForm $("#appunto-small")
  #   miaform.destroy();
  