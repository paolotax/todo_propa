collection @visite

attributes :id, :start, :end

code do |u|
  { 
    title:   u.cliente.titolo,
    allDay:  u.all_day
  }
end