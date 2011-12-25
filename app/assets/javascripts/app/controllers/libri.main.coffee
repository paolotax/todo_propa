Libro = App.Libro

class Show extends Spine.Controller
  className: 'show'

  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'
    'click [data-type=destroy]': 'destroy'

  constructor: ->
    console.log 'show'
    super
    @active @change

  render: ->
    @html @view('libri/show')(@item)

  change: (params) =>
    @item = Libro.find(params.id)
    @render()

  edit: ->
    @navigate '/libri', @item.id, 'edit'

  destroy: (e) ->
    if confirm('Sei sicuro?')
      @item.destroy() 
      @navigate '/libri'

  back: ->
    @navigate '/libri'


class Edit extends Spine.Controller
  className: 'edit'

  events:
    'click [data-type=show]': 'show'
    'click [data-type=back]': 'back'
    'submit form': 'submit'

  constructor: ->
    super
    @active @change

  change: (params) =>
    @item = Libro.find(params.id)
    @render()
    $('select[name=type]').val @item.type
    # $('select[name=materia_id]').val @item.id
    # $('.chosen').chosen()

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


class Main extends Spine.Stack
  controllers:
    edit:  Edit
    show:  Show

  className: 'stack form'
    
window.Main = Main