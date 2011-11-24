class ScuolePager
  constructor: (@page = 1) ->
    $(window).scroll(@check)

  check: =>
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON($('#scuole').data('json-url'), {page: @page}, @render)


  nearBottom: =>
    ($(window).scrollTop() > $(document).height() - $(window).height() - 50) || ($(window).scrollTop() > ($("#scuole").offset().top + $("#scuole").height()))

  render: (scuole) =>
    for scuola in scuole
      $('#scuole').append Mustache.to_html($('#scuola_template').html(), scuola)
    $(window).scroll(@check) if scuole.length > 0 else @new_pager = true



jQuery ->
  if $('#scuole').length
    console.log("scuole present 1: ")
    scuole_pager = new ScuolePager
  if $('#appunti').length
    console.log("scuole present 1: ")
    new AppuntiPager(1)



  $("[data-pjax-container]").bind 'pjax:start', () =>
    $(window).unbind('scroll', @check)
    if $('#scuole').length == 0
      @new_pager = true
      console.log("pjax:start " + scuole_pager.page)

  $("[data-pjax-container]").bind 'pjax:end', () =>
    $('.chzn-select').chosen()
    if $('#scuole').length
      scuole_pager = new ScuolePager if @new_pager == true else $(window).scroll(@check)
      scuole_pager.page = 1
      @new_pager = false
    console.log("pjax:end " + $('#scuole').length)

