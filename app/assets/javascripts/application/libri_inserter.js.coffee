jQuery ->
  
  select = $("#libri_inserter_editore") 
  if select.length == 0
    select = $("#appunto_destinatario")

  if select.length > 0
  
    # // init the chosen plugin
    select.chosen()
    
    # // get the chosen object
    chosen = select.data('chosen');

    # // Bind the keyup event to the search box input
    chosen.dropdown.find('input').on 'keyup', (e) ->
      
      if (e.which == 13 && chosen.dropdown.find('li.no-results').length > 0)
        
        option = $("<option>").val(this.value).text(this.value);

        select.prepend(option);
    
        select.find(option).prop('selected', true)

        select.trigger("liszt:updated")
        $(".active-result.result-selected").addClass("highlighted").focus()

