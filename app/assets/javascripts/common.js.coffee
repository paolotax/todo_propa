jQuery ->
  $('.cliente a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.links.pjax a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.search_options a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.filter a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('.nav a').pjax('[data-pjax-container]', { timeout: 10000 })
  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')
  window.activateTabs() if $('#appunto-small').length
