jQuery ->
  

  rows = $('#classifica.table tbody tr').get()

  console.log rows

  rows.sort (a, b) ->
    console.log "sort"

    A = Number($("td:last", a).html())
    B = Number($("td:last", b).html())

    console.log A
    console.log B

    if (A < B)
      return -1

    if (A > B) 
      return 1
    return 
  
  $.each rows, (index, row) ->
    $('#classifica').children('tbody').append(row)







