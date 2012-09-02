# testCallback = (object, value, settings) ->
#   converter = new Showdown.converter()
#   html = converter.makeHtml value
#   $(object).html html

jQuery ->
  
  $(".mostra-tappe").on "click", (e) ->
    e.preventDefault();
    $("table", $(@).closest(".giro")).toggleClass("hidden");

  $(".mostra-classi").on "click", (e) ->
    e.preventDefault();
    $("table", $(@).closest(".visita")).toggleClass("hidden");
    
    if $(@).text() == 'mostra'
      $(@).text("nascondi")
    else
      $(@).text("mostra")

  $(".show-hide").on "click", (e) ->
    e.preventDefault();
    $(".more", $(@).parent()).toggleClass("hidden");
    if $(@).text() == 'mostra'
      $(@).text("nascondi")
    else
      $(@).text("mostra")    
  
  $(".esandi-tutto").on "click", (e) ->
    e.preventDefault();
    if $(@).text() == 'esandi tutto'
      $(".more").removeClass("hidden")
      $(@).text("nascondi tutto")
      $(".show-hide").each -> $(@).text("nascondi")
      $(".show a").each ->    $(@).trigger "click"  
    else
      $(".more").addClass("hidden");
      $(@).text("esandi tutto")
      $(".show-hide").each -> $(@).text("mostra")
      $(".chiudi a").each ->    $(@).trigger "click"  
      
  $(".break a").live "click", (e) ->
    e.preventDefault();
    $(@).parent().toggleClass("page-break")

  $('#flash_notice, #flash_alert').delay(2000).slideUp('slow')

  $(".on_the_spot_editing, .note_mark").live 'mouseout', ->
    $(@).css 'background-color', 'inherit'
  
  $('.on_the_spot_editing, .note_mark').live 'mouseover', ->
    $(@).css 'background-color', '#EEF2A0'
  
  String.prototype.capitalize = () ->
    this.charAt(0).toUpperCase() + this.slice(1)
  
  $(".filters a, .module.remote a").live 'click', (e) ->
    e.preventDefault()
  
    cont = $(@).attr('href').split('?')[0] ||= ""
    params = $(@).attr('href').split('?')[1] ||= ""
    
    if cont == '/clienti.json'
      controller = 'clienti'
      template = JST['clienti/cliente']
    else
      controller = 'appunti'
      template = JST['appunti/appunto']    
  
    storageName = "pending#{controller.capitalize()}"
    if !localStorage[storageName]
      localStorage[storageName] = JSON.stringify []
  
    $.get "/get_#{controller}_filters.js", params, (data) ->
      console.log data
    
    $.getJSON $(@).attr('href'), (data) ->
      pending = $.parseJSON localStorage[storageName]
      appunti = pending.concat(data)
  
      $("##{controller}").empty()
      for obj in appunti
        if obj.data?
          item = template(obj)
          $(item).hide().appendTo("##{controller}").fadeIn()   
        else
          item = template(obj)
          $(item).hide().appendTo("##{controller}").fadeIn('slow')   
        
        window.initializeAppunto($(".appunto:last-child"))

