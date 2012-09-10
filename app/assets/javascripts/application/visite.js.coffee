jQuery ->
  
  $("#calendar").fullCalendar
    header:
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    
    
    editable: true,
    draggable: true,
    droppable: true,
    defaultView: 'agendaWeek',
    
    allDayText: '',
    axisFormat: 'H:mm',
    firstHour: 7,
    minTime: 7,
    maxTime: 20,
    defaultEventMinutes: 30,
    
    columnFormat:
      month: 'ddd'
      week: 'ddd d/M'
      day: 'dddd d/M'
        
    titleFormat:
      month: 'MMMM yyyy'
      week: "d MMM[ yyyy]{ '-'[ d] MMM yyyy}"
      day: 'dddd, d MMM yyyy'
    
    eventResize: (event,dayDelta,minuteDelta,revertFunc) ->
      updateEvent(event);

    eventDrop: (event, dayDelta, minuteDelta, allDay, revertFunc) ->
      updateEvent(event);
        
    monthNames:      ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'],
    monthNamesShort: ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'],
    dayNames:        ['Domenica', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato'],
    dayNamesShort:   ['Dom', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab'],

    eventSources: [
      {
        url: '/visite.json', 
        ignoreTimezone: false        
      }
    ]     
    
    firstDay: 1,
    selectable: true,
    timeFormat:
      agendaWeek: ' '
    
    # eventRender: (event, element) ->
    #   element.find('.fc-event-title')
    
  $('#visita_data').datepicker
    dateFormat: 'dd-mm-yy'

updateEvent = (event) ->
  $.ajax
    type: 'put'
    data: 
      'visita':
        start: event.start.toString() 
        end:   event.end.toString()
    url: '/visite/' + event.id + '.json',
    success: (data) ->
      console.log "Sboccio"
