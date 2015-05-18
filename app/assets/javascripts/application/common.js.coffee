# testCallback = (object, value, settings) ->
#   converter = new Showdown.converter()
#   html = converter.makeHtml value
#   $(object).html html

document.addEventListener "page:fetch", ->
  $("#loading").show()

document.addEventListener "page:receive", ->
  $("#loading").hide()
  

jQuery ->

  $( '.cb-toggle' ).on 'click', () ->
    $( 'input[type="checkbox"]', $(@).parent()).prop('checked', this.checked)

  $( '.select-all' ).on 'click', () ->
    $( 'input[type="checkbox"]', $(@).parent().parent()).prop('checked', this.checked)


  $('form').on 'focus', 'input[type=number]', (e) ->
    $(@).on 'mousewheel.disableScroll', (e) ->
      e.preventDefault()
  
  $('form').on 'blur', 'input[type=number]', (e) ->
    $(@).off 'mousewheel.disableScroll'


  $('input[type=file]').bootstrapFileInput()
  

  $("#loading").on "ajaxSend", () ->
    $("#loading").show()
  
  $("#loading").on "ajaxComplete", () ->
    $("#loading").hide()
  
  
  $(".cb-appunto").on "change", (e) ->
    e.preventDefault();
    if $(@).is(":checked") is false
      $("input:hidden[name='appunto_ids[]'][value='#{$(@).val()}']").remove()
    else
      $("#form_print_appunti").prepend("<input type='hidden' name='appunto_ids[]' value='#{$(@).val()}' />")


  $(".cb-appunto-item").on "change", (e) ->
    e.preventDefault();
    if $(@).is(":checked") is false
      $("input:hidden[name='appunto_ids[]'][value='#{$(@).val()}']").remove()
    else
      cliente = $(@).closest($('.box-registra'))
      $("form", cliente).prepend("<input type='hidden' name='appunto_ids[]' value='#{$(@).val()}' />")

  $(".cb-riga-item").on "change", (e) ->

    e.preventDefault();
    if $(@).is(":checked") is false
      console.log "false"
      $("input:hidden[name='riga_ids[]'][value='#{$(@).val()}']").remove()
    else
      cliente = $(@).closest($('.box-consegna'))
      $("form", cliente).prepend("<input type='hidden' name='riga_ids[]' value='#{$(@).val()}' />")

      
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
    $(".more:first", $(@).closest('.header').closest(".module")).toggleClass("hidden")
    if $("i", $( @)).hasClass('icon-caret-down')
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
  
