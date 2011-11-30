class ListPager
  constructor: (@page = 1, @list, @template) ->
    $(window).scroll(@check)
    console.log(list)
    console.log(template)

  check: =>
    if @nearBottom()
      console.log "scrollTop: " + $(window).scrollTop()
      console.log "docHeigth: " + $(document).height()
      console.log "winHeigth: " + $(window).height()
      console.log ">  scroll:  " + ($(document).height() - $(window).height() - 50)
      console.log "list top:  " + @list.offset().top
      console.log "list bottom:  " + (@list.offset().top + @list.height())
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON(@list.data('json-url'), {page: @page}, @render)
      $('.on_the_spot_editing').each initializeOnTheSpot
	
  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 50  or $(window).scrollTop() + $(window).height() + 50 > @list.offset().top + @list.height() 

  render: (objs) =>
    for obj in objs
      console.log(obj)
      @list.append Mustache.to_html(@template.html(), obj)
    $(window).scroll(@check) if objs.length > 0 else @new_pager = true



jQuery ->
  if $('#scuole').length
    scuole_pager = new ListPager(1, $("#scuole"), $('#scuola_template'))
  if $('#appunti').length
    appunti_pager = new ListPager(1, $("#appunti"), $('#appunto_template'))




  $("[data-pjax-container]").bind 'pjax:start', () =>
    $(window).unbind('scroll', @check)
    if $('#scuole').length == 0
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
      scuole_pager = new ListPager(1, $("#scuole"), $('#scuola_template')) if @new_pager == true else $(window).scroll(@check)
      @new_pager = false
    if $('#appunti').length
      scuole_pager = new ListPager(1, $("#appunti"), $('#appunto_template')) if @new_pager == true else $(window).scroll(@check)
      @new_pager = false


