# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('.scuola a').pjax('[data-pjax-container]')
  $('.links a').pjax('[data-pjax-container]')
  $('.search_options a').pjax('[data-pjax-container]')
  $('.filter a').pjax('[data-pjax-container]')



