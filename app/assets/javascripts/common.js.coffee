jQuery ->
  $('.pjax a').pjax('[data-pjax-container]', { timeout: 10000 })
  
  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length
