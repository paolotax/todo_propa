class ListPager
  constructor: (@page = 1, @list, @template, @model) ->
    if @page is 1
      $.getJSON(@list.data('json-url'), {page: @page}, @render)

  check: =>
    if @nearBottom()
      @page++
      @list.unbind('scroll', @check)
      @pos = @list.scrollTop();
      $.getJSON(@list.data('json-url'), {page: @page}, @render)
      
  nearBottom: =>
    @list.offset().top + @list.height() > $(".#{@model}:last-child").position().top + $(".#{@model}:last-child").height() - 10

  render: (objs) =>
    for obj in objs
      @list.append Mustache.to_html(@template.html(), obj)
      
    @list.scrollTop(@pos)
    @list.bind('scroll', @check) if objs.length > 0


jQuery ->
  if $('#clienti').length
    clienti_pager = new ListPager(1, $("#clienti"), $('#cliente_template'), 'cliente')

  if $('#appunti').length
    appunti_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto')


  $("[data-pjax-container]").bind 'pjax:start', () =>
    $(window).unbind('scroll', @check)
    
    
  $("[data-pjax-container]").bind 'pjax:end', () =>

    $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})

    window.activateTabs() if $('#appunto-small').length
        
    $('.on_the_spot_editing').each initializeOnTheSpot

    if $('#clienti').length
      clienti_pager = new ListPager(1, $("#clienti"), $('#cliente_template'), 'cliente')
    if $('#appunti').length
      appunti_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto')
