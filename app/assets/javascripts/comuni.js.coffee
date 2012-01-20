jQuery ->
  $('#cliente_provincia').live 'change', ->
    provincia = $('#cliente_provincia :selected').text()
    comuni = new ListComuni(provincia)

class ListComuni
  
  constructor: (@provincia = '') ->
    @list_provincie = $('#cliente_provincie')
    @list_citta     = $('#cliente_citta')
    @list_citta.live 'change', @fill_address
    @get_comuni()
        
  get_comuni: () =>
    $.getJSON "/comuni.json", { 'per_provincia': @provincia }, @render
  
  render: (objs) =>
    @comuni = objs
    @list_citta.empty()
    @list_citta.append("<option></option")
    for c in objs
      @list_citta.append("<option>#{c.comune}</option")
    @list_citta.trigger("liszt:updated")

  fill_address: () =>
    @comune = $('#cliente_citta :selected').text()
    console.log @comune
    for c in @comuni
      console.log c
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
  # if $('.cliente .map').length
  #   @cliente = new Cliente()
  # 
  # $("[data-pjax-container]").bind 'pjax:end', () =>
  #   window.comuni = $('#cliente_citta').html()
  #   $('#cliente_provincia').trigger 'change'
  #   if $('.cliente .map').length
  #     @cliente = new Cliente()


