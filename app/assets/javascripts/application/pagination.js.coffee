jQuery ->
  isScrolledIntoView = (elem) ->
    docViewTop = $(window).scrollTop()
    docViewBottom = docViewTop + $(window).height()
    elemTop = $(elem).offset().top
    elemBottom = elemTop + $(elem).height()
    (elemTop >= docViewTop) && (elemTop <= docViewBottom)
  
  if $('.pagination').length
    $(window).scroll ->
      url = $('.pagination .next a').attr('href')
      if url && isScrolledIntoView('.pagination')
        $('.pagination').text("Fetching more products...")
        $.getScript(url)
    $(window).scroll()