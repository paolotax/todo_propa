# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->

  if $('.floating-side').length > 0

    length = $('.floating-side').height() - $('.floating-toolbar').height() + $('.floating-side').offset().top
    width  = $('.floating-side').width()
    
    $(window).scroll () ->

      scroll = $(@).scrollTop()
      height = $('.floating-toolbar').height() + 'px'

      if (scroll < $('.floating-side').offset().top)

        $('.floating-toolbar').css
          'position': 'absolute',
          'top': '0',
          'width': width + 'px'
      
      else if (scroll > length)

        $('.floating-toolbar').css
          'position': 'absolute',
          'top': 'auto',
          'bottom': '0',
          'width': width + 'px'

      else

        $('.floating-toolbar').css
          'position': 'fixed',
          'top': '50px',
          'height': height,
          'width': width + 'px'
         
