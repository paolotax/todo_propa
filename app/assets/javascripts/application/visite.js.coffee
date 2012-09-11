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
    firstHour: 8,
    minTime: 8,
    maxTime: 16,
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
        url: '/visite.json'
        currentTimezone: "Rome"       
      }
    ]     
    
    firstDay: 1,
    selectable: true,
    
    timeFormat:
      agendaWeek: ' '
    
    ignoreTimezone: false
 
    # eventRender: (event, element) ->
    #   element.find('.fc-event-title')
    
  $('#visita_data').datepicker
    dateFormat: 'dd-mm-yy'

updateEvent = (event) ->
  $.ajax
    type: 'put'
    data: 
      'visita':
        all_day: event.allDay
        start: event.start.toString() 
        end:   event.end.toString()
    url: '/visite/' + event.id + '.json',
    success: (data) ->
      console.log "Sboccio"
