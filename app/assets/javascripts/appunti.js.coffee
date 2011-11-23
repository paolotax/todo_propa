# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


jQuery ->
  
  if $('#appunti').length
    new AppuntiPager()
    
  $('.appunto a').pjax('[data-pjax-container]')
  $('.chzn-select').chosen()

  $("[data-pjax-container]").bind 'pjax:end', () =>
    $('.chzn-select').chosen()
    if $('#appunti').length
      new AppuntiPager()
  

  obj = $("#appunti")
  p = obj.offset().top + obj.height()
  console.log(p)


class AppuntiPager
  constructor: (@page = 1) ->
    $(window).scroll(@check)
  
  check: =>
    if @nearBottom()
      console.log("scrollTop: " + $(window).scrollTop())
      console.log("docHeigth: " + $(document).height())
      console.log("winHeigth: " + $(window).height())
      console.log(">  scroll:  " + ($(document).height() - $(window).height() - 50))
      
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON($('#appunti').data('json-url'), {page: @page}, @render)

  nearBottom: =>
    $(window).scrollTop() > $(document).height() - $(window).height() - 50
    # $(window).scrollTop() > $(document).height() - $('#appunti').height() - 50
    
    
  render: (appunti) =>
    for appunto in appunti
      $('#appunti').append Mustache.to_html($('#appunto_template').html(), appunto)
    $(window).scroll(@check) if appunti.length > 0
