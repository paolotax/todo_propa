$ = Spine.$

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Libro.find(elementID)

class Spine.List extends Spine.Controller
  events:
    "click .item": "click"

  events:
    "click .item": "click"
  
  selectFirst: false

  constructor: ->
    console.log "new list"
    super
    @bind("change", @change)

  template: -> arguments[0]

  change: (item) =>
    console.log 'change template'
    return unless item
    @current = item
    @children().removeClass("active")
    @children().forItem(@current).addClass("active")
  
  render: (items) ->
    console.log 'render template', items.length

    @items = items if items

    @html @template(@items)

    @change @current
    if @selectFirst
      unless @children(".active").length
        @children(":first").click()
        
  children: (sel) ->
    @el.children(sel)
    
  click: (e) ->
    item = $(e.target).item()
    @trigger("change", item)
   
window.List = Spine.List