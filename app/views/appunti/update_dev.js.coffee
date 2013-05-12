appunto = $("#<%= dom_id(@appunto) %>")

opened     = appunto.hasClass("opened")
grouped    = appunto.hasClass("grouped")

if appunto.hasClass("da_fare")
  old_status = "da_fare"
else if appunto.hasClass("preparato")
  old_status = "preparato"
else if appunto.hasClass("in_sospeso")
  old_status = "in_sospeso"
else if appunto.hasClass("completato")  
  old_status = "completato"
  
if grouped
  appunto.replaceWith("<%= j render @appunto, grouped: 'grouped' %>");
else
  appunto.replaceWith("<%= j render @appunto %>");

if opened
  $("#<%= dom_id(@appunto) %>").addClass("opened")

new_status = "<%= @appunto.status %>"

incrementStatus = (status) ->
  value = $(".stats li.#{status} a strong").text()
  value++
  $(".stats li.#{status} a strong").html(value)
  
decrementStatus = (status) ->
  value = $(".stats li.#{status} a strong").text()
  value--
  $(".stats li.#{status} a strong").html(value)
  

if old_status isnt new_status
  decrementStatus("da-fare")    if old_status is "da_fare"
  decrementStatus("preparato")  if old_status is "preparato"
  decrementStatus("in-sospeso") if old_status is "in_sospeso"
  incrementStatus("da-fare")    if new_status is "da_fare"
  incrementStatus("preparato")    if new_status is "preparato"
  incrementStatus("in-sospeso") if new_status is "in_sospeso"