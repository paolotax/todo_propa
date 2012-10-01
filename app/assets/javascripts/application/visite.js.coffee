jQuery ->



  $('.clienti .cliente').live 'mouseover', ->
    
    eventObject =
      title: $(".titolo a", @).text()
      id:    $(@).data('id')

    # store the Event Object in the DOM element so we can get to it later
    $(@).data('eventObject', eventObject);

    # make the event draggable using jQuery UI
    $(@).draggable
      zIndex: 999
      revert: true        # will cause the event to go back to its
      revertDuration: 0   #  original position after the drag

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
    
    drop: (date, allDay) ->     # this function is called when something is dropped
      # retrieve the dropped element's stored Event Object
      originalEventObject = $(@).data('eventObject');
      console.log originalEventObject
      # we need to copy it, so that multiple events don't have a reference to the same object
      copiedEventObject = $.extend({}, originalEventObject);

      # assign it the date that was reported
      copiedEventObject.start = date;
      copiedEventObject.end   = new Date(date.getTime() + 30*60000);
            
      copiedEventObject.allDay = allDay;

      $.ajax
        type: 'post',
        data: 
          'visita': 
            cliente_id: copiedEventObject.id
            start: copiedEventObject.start.toString()
            end:   copiedEventObject.end.toString()
            baule: false
            
        url: '/visite',
        
        dataType: 'json',

        success: (data) =>
          # render the event on the calendar
          console.log copiedEventObject
          console.log $(@)
          # the last `true` argument determines if the event "sticks" (http://arshaw.com/fullcalendar/docs/event_rendering/renderEvent/)
          $('#calendar').fullCalendar('renderEvent', copiedEventObject);
          # $('#calendar').fullCalendar('renderEvents');
          $(@).remove();
    
    
    events:
      url: '/visite.json'
    
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
