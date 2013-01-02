jQuery ->
  initialize_comuni = ->
    if $('#cliente_provincia').length
      lista_comuni = new ListComuni()
      
  initialize_comuni()

class ListComuni
  
  constructor: () ->
    @list_provincia = $('#cliente_provincia')
    @list_citta     = $('#cliente_comune')

    @provincia      = $(':selected', @list_provincia).text()
    @comune         = $(':selected', @list_citta).text()
    
    @list_provincia.live 'change', @change
    @list_citta.live     'change', @change_citta

  get_comuni: () =>
    $.getJSON "/comuni.json", { 'per_provincia': @provincia }, @render

  render: (objs) =>
    @list_citta.empty().append("<option></option")
    @comuni = objs
    console.log @comuni
    for c in @comuni
      @list_citta.append("<option>#{c["comune"].comune}</option")
    @list_citta.trigger("liszt:updated")

  change: () =>
    @provincia = $(':selected', @list_provincia).text()
    @get_comuni()
    $('#cliente_provincia').val ''
    $('#cliente_citta').val     ''
    $('#cliente_cap').val       ''

  change_citta: () =>
    @comune = $(':selected', @list_citta).text()
    unless @comuni?
      $.getJSON "/comuni.json", { 'per_provincia': @provincia }, (response) =>
        @comuni = response
        @fill_address()
    else
      @fill_address()
    
  fill_address:() =>  
    for comune in @comuni
      c = comune["comune"]
      if c.provincia is @provincia and c.comune is  @comune
        $('#cliente_provincia').val @provincia
        $('#cliente_citta').val     @comune
        $('#cliente_cap').val       c.cap

