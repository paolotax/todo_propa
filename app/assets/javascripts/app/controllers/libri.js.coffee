$ = jQuery.sub()
Libro = App.Libro

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Libro.find(elementID)

class Sidebar extends Spine.Controller
  className: 'sidebar'

  elements:
    '.items': 'items'

  events:
    'click [data-type=filter]':  'filter'
    'click [data-type=show]':    'show'
    'click [data-type=edit]':    'edit'
    'click .item': 'show'

  constructor: ->
    super
    @html @view('libri/sidebar')()    

    Libro.bind 'fetch', =>
      @el.addClass('loading')

    Libro.bind 'refresh', (e) =>
      @el.removeClass('loading')
      @render(arguments...)

    Libro.bind 'change', (item) =>
      console.log ".item[data-id='#{item.id}']"
      $(".item[data-id='#{item.id}']").html @view('libri/item')(item)
       
  filter: (e) ->
    @query = $(e.target).text()
    console.log @query
    @render()
  
  render: (items = []) =>
    console.log items
    for item in items
      console.log 'append'
      @items.append @view('libri/item')(item)

    # libri = Libro.filter(@query).sort(Libro.titoloSort)
    # @html @view('libri/index')(libri: libri)
  
  show: (e) =>
    item = $(e.target).item()
    console.log item.id
    @navigate '/libri', item.id
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/libri', item.id, 'edit'


class App.Libri extends Spine.Controller
  className: 'libri'
    
  constructor: ->
    super
    
    @sidebar = new Sidebar
    @main    = new Main
    
    @routes
      '/libri/:id': (params) ->
        @sidebar.active(params)
        @main.show.active(params)
      '/libri/:id/edit': (params) -> 
        @sidebar.active(params)
        @main.edit.active(params)
    
    divide = $('<div />').addClass('vdivide')

    @append @sidebar , divide, @main

    Libro.fetch()

