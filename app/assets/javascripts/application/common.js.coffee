# testCallback = (object, value, settings) ->
#   converter = new Showdown.converter()
#   html = converter.makeHtml value
#   $(object).html html

jQuery ->
  
  
  $(".cb-appunto").on "change", (e) ->
    e.preventDefault();
    if $(@).is(":checked") is false
      $("input:hidden[name='appunto_ids[]'][value='#{$(@).val()}']").remove()
    else
      $("#form_print_appunti").prepend("<input type='hidden' name='appunto_ids[]' value='#{$(@).val()}' />")
      
      
    
  
  
  # $('#btn-pdf').live 'click', (e) ->
  #   e.preventDefault();
  #   params = $("#form_appunti").serialize()
  #   $('#form_appunti').attr({'action': "/appunti/print_multiple", 'method': 'post'});
  #   $('#form_appunti').submit();
  #   return false
   
     
  
  $(".mie-adozioni span.adozioni").live "click", (e) ->
    
    id = $(@).parent().parent().data("id")
    e.preventDefault()
    $('.the-modal').modal().open
          
      onOpen: (el, options) ->
        el.html("<div class='the-modal'></div>");
        $(".the-modal", el).append("<div class='the-close'>&times</div>");
        $(".the-modal", el).append("<div class='appunti'></div>");  
        
        $.ajax 
          url: "/appunti.json?cliente_id=#{id}"
          dataType: 'json'
          success: (data) ->
            for obj in data
              $(".appunti", el).append  JST['appunti/appunto'](obj);


  $(".mostra-classi").on "click", (e) ->
    e.preventDefault();
    $("table", $(@).closest(".visita")).toggleClass("hidden");
    
    if $(@).text() == 'mostra'
      $(@).text("nascondi")
    else
      $(@).text("mostra")

  $(".show-hide").on "click", (e) ->
    e.preventDefault();
    $(".more", $(@).parent().parent()).toggleClass("hidden");
    
    if $("i", $(@)).hasClass('icon-caret-down')
      $("i", $(@)).removeClass('icon-caret-down');
      $("i", $(@)).addClass('icon-caret-up');
    else
      $("i", @).removeClass('icon-caret-up')
      $("i", @).addClass('icon-caret-down')      
    
  $(".esandi-tutto").on "click", (e) ->
    e.preventDefault();
    if $(@).text() == 'esandi tutto'
      $(".more").removeClass("hidden")
      $(@).text("nascondi tutto")
      $(".show-hide").each -> 
        $("i", $(@)).removeClass('icon-caret-down');
        $("i", $(@)).addClass('icon-caret-up');
      $(".show a").each ->    $(@).trigger "click"  
    else
      $(".more").addClass("hidden");
      $(@).text("esandi tutto")
      $(".show-hide").each ->
        $("i", @).removeClass('icon-caret-up')
        $("i", @).addClass('icon-caret-down')
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
  
  $(".filters a, .module.remote a, #tag_cloud a").live 'click', (e) ->
    e.preventDefault()
    
    url = $(@).attr('href')
    cont = url.split('?')[0] ||= ""
    params = url.split('?')[1] ||= ""
    
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
      console.log "data"
    
    $.ajax
      url: controller + "?" + params
      dataType: "script"
      success: () ->
        console.log "yeah"
        
    # $.getJSON url, (data) ->
    #   pending = $.parseJSON localStorage[storageName]
    #   appunti = pending.concat(data)
    #   
    #   $("##{controller}").empty()
    #   for obj in appunti
    #     if obj.data?
    #       item = template(obj)
    #       $(item).hide().appendTo("##{controller}").fadeIn()   
    #     else
    #       item = template(obj)
    #       $(item).hide().appendTo("##{controller}").fadeIn()   
    #     
    #     window.initializeAppunto($(".appunto:last-child"))
      
      # window.history.pushState null, "appunti", url;  
