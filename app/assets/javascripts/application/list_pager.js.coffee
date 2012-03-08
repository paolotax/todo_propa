class ListPager
  constructor: (@page = 1, @list, @template, @model) ->
    $(window).bind 'scroll', @check

  check: => 
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON(@list.data('json-url'), {page: @page}, @render)
      
  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 100  or $(window).scrollTop() + $(window).height() + 50 > @list.offset().top + @list.height() 
  
  render: (objs) =>
    for obj in objs
      @list.append @template(obj)
    
    $('time.timeago').timeago();  
    $(window).bind('scroll', @check) if objs.length > 0

  reset: ->
    @page = 1
    $(window).bind('scroll', @check)

jQuery ->

  if $('#clienti').length
    window.clienti_pager = new ListPager(1, $("#clienti"), $('#cliente_template'), 'cliente')

  if $('#appunti').length
    window.appunti_pager = new ListPager(1, $("#appunti"), JST['appunti/appunto'], 'appunto')
      
