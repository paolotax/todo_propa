# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  if $('#scuole').length
    scuole_pager = new ScuolePager

  $('.scuola a').pjax('[data-pjax-container]')
  $('.links a').pjax('[data-pjax-container]')
  $('.search_options a').pjax('[data-pjax-container]')
  $('.filter a').pjax('[data-pjax-container]')
  
  $("[data-pjax-container]").bind 'pjax:end', () =>
    $('.chzn-select').chosen()
    if $('#scuole').length
      scuole_pager = new ScuolePager if @new_pager == true
      scuole_pager.page = 1
      @new_pager = false

class ScuolePager
  constructor: (@page = 1) ->
    $(window).scroll(@check)

  check: =>
    if @nearBottom()
      @page++
      $(window).unbind('scroll', @check)
      $.getJSON($('#scuole').data('json-url'), {page: @page}, @render)

  nearBottom: =>
    ($(window).scrollTop() > $(document).height() - $(window).height() - 50) || ($(window).scrollTop() > ($("#scuole").offset().top + $("#scuole").height()))
		
  render: (scuole) =>
    for scuola in scuole
      $('#scuole').append Mustache.to_html($('#scuola_template').html(), scuola)
    $(window).scroll(@check) if scuole.length > 0 else @new_pager = true

