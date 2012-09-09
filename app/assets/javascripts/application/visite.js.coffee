jQuery ->
  
  $("#calendar").fullCalendar
    
    defaultView: 'agendaWeek',
    
    
    monthNames:      ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno', 'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'],
    monthNamesShort: ['Gen', 'Feb', 'Mar', 'Apr', 'Mag', 'Giu', 'Lug', 'Ago', 'Set', 'Ott', 'Nov', 'Dic'],
    dayNames:       ['Domenica', 'Lunedì', 'Martedì', 'Mercoledì', 'Giovedì', 'Venerdì', 'Sabato'],
    dayNamesShort:  ['Dom', 'Lun', 'Mar', 'Mer', 'Gio', 'Ven', 'Sab']
    
    eventSources: [
      {
        url: '/visite.json', 
        textColor: 'black',
        ignoreTimezone: false        
      }
    ]  

    
  
  
  $('#visita_data').datepicker
    dateFormat: 'dd-mm-yy'
  