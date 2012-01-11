class ListPager
  constructor: (@page = 1, @list, @template, @model) ->
    $(window).scroll(@check)

  check: =>
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON(@list.data('json-url'), {page: @page}, @render)

  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 50  or $(window).scrollTop() + $(window).height() + 50 > @list.offset().top + @list.height() 

  render: (objs) =>
    for obj in objs
      @list.append Mustache.to_html(@template.html(), obj)
      riga =  $("##{@model}_#{obj.id}")
      $(".on_the_spot_editing", riga).each initializeOnTheSpot
    $.mask.fit()
    $(window).scroll(@check) if objs.length > 0 else @new_pager = true


jQuery ->
  if $('#scuole').length
    scuole_pager = new ListPager(1, $("#scuole"), $('#scuola_template'), 'scuola')
  if $('#appunti').length
    appunti_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto')


  $("[data-pjax-container]").bind 'pjax:start', () =>
    $(window).unbind('scroll', @check)
    if $('#scuole').length == 0
      @new_pager = true
    if $('#appunti').length == 0
      @new_pager = true

  $("[data-pjax-container]").bind 'pjax:end', () =>

    window.activateTabs() if $('#appunto-small').length
    
    $('.on_the_spot_editing').each initializeOnTheSpot
    $(".scrollable").scrollable  
      vertical: true, 
      mousewheel: true,
      circular: true 
    $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})
    if $('#scuole').length
      scuole_pager = new ListPager(1, $("#scuole"), $('#scuola_template'), 'scuola') if @new_pager == true else $(window).scroll(@check)
      @new_pager = false
    if $('#appunti').length
      scuole_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto') if @new_pager == true else $(window).scroll(@check)
      @new_pager = false


