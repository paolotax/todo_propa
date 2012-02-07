jQuery ->
  if $.support.localStorage
    $(window.applicationCache).bind "error", () ->
      console.log("There was an error when loading the cache manifest.");
    
    if !localStorage["pendingItems"]
      localStorage["pendingItems"] = JSON.stringify []

    $.retrieveJSON "/appunti.json" + window.location.search, (data) ->
      pendingItems = $.parseJSON localStorage["pendingItems"]
      appunti = data.concat(pendingItems)
      $("#appunti").empty()
      for obj in appunti
        $("#appunti").append Mustache.to_html($("#appunto_template").html(), obj)       
      # $("#appunti").html($("#item_template").tmpl(data.concat(pendingItems)));


    $("#new_appunto").submit (e) ->
      pendingItems = $.parseJSON localStorage["pendingItems"];
      # item = {[data]($(this).serialize(),) [appunto]({"cliente_id":$("#appunto_cliente_id").val()}};)

      console.log item
              
      # pendingItems.push(item);
      # localStorage["pendingItems"] = JSON.stringify(pendingItems)
      # $("#item_name").val("");
      # sendPending();
      
      e.preventDefault();




    sendPending = ->
      if window.navigator.onLine
        pendingItems = $.parseJSON localStorage["pendingItems"]
        if pendingItems.length > 0
          item = pendingItems[0]
          $.post "/appunti", item.data, (data) ->
            pendingItems = $.parseJSON localStorage["pendingItems"]
            pendingItems.shift()
            localStorage["pendingItems"] = JSON.stringify(pendingItems)
            setTimeout(sendPending, 100)

    sendPending()

    $(window).bind "online", sendPending

  else
    alert "Try a different browser."


class ListPager
  constructor: (@page = 1, @list, @template, @model) ->
    @list.bind 'scroll', @check
    # if @page is 1
    #   $.getJSON(@list.data('json-url'), {page: @page}, @render)

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
      
  # $("[data-pjax-container]").bind 'pjax:start', () =>
  #   $(window).unbind('scroll', @check)
  #   
  #   
  # $("[data-pjax-container]").bind 'pjax:end', () =>
  # 
  #   $('.chzn-select').chosen({no_results_text: "Nessuna corrispondenza trovata"})
  # 
  #   window.activateTabs() if $('#appunto-small').length
  #       
  #   $('.on_the_spot_editing').each initializeOnTheSpot
  # 
  #   if $('#clienti').length
  #     clienti_pager = new ListPager(1, $("#clienti"), $('#cliente_template'), 'cliente')
  #   if $('#appunti').length
  #     appunti_pager = new ListPager(1, $("#appunti"), $('#appunto_template'), 'appunto')
