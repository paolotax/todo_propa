class ListPager
  constructor: (@page = 1, @list, @template, @model) ->
    $(window).scroll(@check)
    console.log(list)
    console.log(template)

  check: =>
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON(@list.data('json-url'), {page: @page}, @render)

  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 50  or $(window).scrollTop() + $(window).height() + 50 > @list.offset().top + @list.height() 

  render: (objs) =>
    for obj in objs
      @list.append Mustache.to_html(@template.html(), obj[@model])
      riga =  $("##{@model}_#{obj[@model]['id']}")
      $(".on_the_spot_editing", riga).each initializeOnTheSpot
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
      console.log("pjax:start " + @page)
    if $('#appunti').length == 0
      @new_pager = true
      console.log("pjax:start " + @page)
	  

  $("[data-pjax-container]").bind 'pjax:end', () =>
    $('.on_the_spot_editing').each initializeOnTheSpot
    $(".scrollable").scrollable  
      vertical: true, 
      mousewheel: true,
      circular: true 
    $('.chzn-select').chosen()
    if $('#scuole').length
      scuole_pager = new ListPager(1, $("#scuole"), $('#scuola_template'), 'scuola') if @new_pager == true else $(window).scroll(@check)
      @new_pager = false
    if $('#appunti').length
      scuole_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto') if @new_pager == true else $(window).scroll(@check)
      @new_pager = false


