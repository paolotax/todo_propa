jQuery ->
  
  rows = $('#classifica.table tbody tr').get()
  rows.sort (a, b) ->
    A = Number($("td:last", a).html())
    B = Number($("td:last", b).html())
    if (A < B)
      return -1
    if (A > B) 
      return 1
    return 
  
  $.each rows, (index, row) ->
    $('#classifica').children('tbody').append(row)


  if $('#adozioni_chart').length > 0
    Morris.Bar
      element: 'adozioni_chart'
      data: $('#adozioni_chart').data('adozioni')
      xkey: "label"
      ykeys: ["value"]
      labels: $('#adozioni_chart').data('labels')
      hideHover: false
      hoverCallback:  (index, options, content, row) ->
        return "<div class='morris-hover-row-label'>" + row.label + "</div><div class='morris-hover-point' style='color: #0b62a4'>" + $('#adozioni_chart').data('labels') + ": " + row.value + "</div>"





