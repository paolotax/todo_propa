jQuery ->
  initialize_comuni = ->
    if $('#cliente_provincia').length
      lista_comuni = new ListComuni()
      
  $("[data-pjax-container]").bind 'pjax:end', () =>
    initialize_comuni()
  
  initialize_comuni()

class ListComuni
  
  constructor: () ->
    @list_provincia = $('#cliente_provincia')
    @list_citta     = $('#cliente_citta')

    @provincia      = $(':selected', @list_provincia).text()
    @comune         = $(':selected', @list_citta).text()

    @list_provincia.live 'change', @change
    @list_citta.live     'change', @change_citta

  get_comuni: () =>
    $.getJSON "/comuni.json", { 'per_provincia': @provincia }, @render

  render: (objs) =>
    @list_citta.empty().append("<option></option")
    @comuni = objs
    for c in @comuni
      @list_citta.append("<option>#{c.comune}</option")
    @list_citta.trigger("liszt:updated")

  change: () =>
    @provincia = $(':selected', @list_provincia).text()
    @get_comuni()
    $('#cliente_indirizzi_attributes_0_provincia').val ''
    $('#cliente_indirizzi_attributes_0_citta').val     ''
    $('#cliente_indirizzi_attributes_0_cap').val       ''

  change_citta: () =>
    @comune = $(':selected', @list_citta).text()
    unless @comuni?
      $.getJSON "/comuni.json", { 'per_provincia': @provincia }, (response) =>
        @comuni = response
        @fill_address()
    else
      @fill_address()
    
  fill_address:() =>  
    for c in @comuni
      if c.provincia is @provincia and c.comune is  @comune
        $('#cliente_indirizzi_attributes_0_provincia').val @provincia
        $('#cliente_indirizzi_attributes_0_citta').val     @comune
        $('#cliente_indirizzi_attributes_0_cap').val       c.cap

    
  # window.comuni = $('#cliente_citta').html()
  # 
  # $('#cliente_provincia').live 'change', ->
  #   provincia = $('#cliente_provincia :selected').text()
  #   escaped_provincia = provincia.replace(/([ #;&,.+*~\':"!^$[\]()=>|\/@])/g, '\\$1')
  #   options = $(window.comuni).filter("optgroup[label='#{escaped_provincia}']").html()
  #   if options
  #     $('#cliente_citta').html(options)
  #     $('#cliente_citta').prepend("<option value></option>")
  #     $("#cliente_citta.chzn-select").trigger("liszt:updated");
  #   else
  #     $('#cliente_citta').empty()
  #   $('#cliente_indirizzi_attributes_0_provincia').val provincia
  #   $('#cliente_citta').trigger 'change'
  #   
  # $('#cliente_citta').live 'change', ->
  #   $('#cliente_indirizzi_attributes_0_citta').val $('#cliente_citta :selected').text()
  # 
  # $('#cliente_provincia').trigger 'change'
  # 
  


