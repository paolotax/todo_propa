$ = jQuery.sub()
Libro = App.Libro

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Libro.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('libri/new')

  back: ->
    @navigate '/libri'

  submit: (e) ->
    e.preventDefault()
    libro = Libro.fromForm(e.target).save()
    @navigate '/libri', libro.id if libro



    
class Edit extends Spine.Controller
  events:
    'click [data-type=show]': 'show'
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Libro.find(id)
    @render()
    $('select[name=type]').val @item.type
    $('select[name=materia_id]').val @item.id
    $('.chosen').chosen()
    
  render: ->
    @html @view('libri/edit')(@item)
    
    

  back: ->
    @navigate '/libri'

  show: ->
    @navigate '/libri', @item.id
    
  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/libri', @item.id
    
    
class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'
    'click [data-type=destroy]': 'destroy'
    
  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Libro.find(id)
    @render()

  render: ->
    @html @view('libri/show')(@item)

  edit: ->
    @navigate '/libri', @item.id, 'edit'
  
  destroy: (e) ->
    if confirm('Sei sicuro?')
      @item.destroy() 
      @navigate '/libri'
    
  back: ->
    @navigate '/libri'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'
    'click [data-type=filter]':  'filter'

  constructor: ->
    super
    Libro.bind 'refresh change', @render
    Libro.fetch()
    
  render: =>
    libri = Libro.filter(@query).sort(Libro.titoloSort)
    console.log libri
    #libri = Libro.all().sort(Libro.titoloSort)
    @html @view('libri/index')(libri: libri)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/libri', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sei sicuro?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/libri', item.id
  
  new: ->
    @navigate '/libri/new'
  
  filter: (e) ->
    @query = $(e.target).text()
    console.log @query
    @render()
  
  # filter: (e) ->
  #   query = $(e.target).text()
  #   libri = []
  #   Libro.select (c) ->
  #     if c.type is query then libri.push c
  # 
  #   for l in libri.sort(Libro.titoloSort)
  #     console.log l.titolo
      
class App.Libri extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/libri/new':      'new'
    '/libri/:id/edit': 'edit'
    '/libri/:id':      'show'
    '/libri':          'index'
    
  default: 'index'
  className: 'stack libri'