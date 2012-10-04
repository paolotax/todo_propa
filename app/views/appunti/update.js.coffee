appunto = $("#<%= dom_id(@appunto) %>")

opened     = appunto.hasClass("opened")
grouped    = appunto.hasClass("grouped")

if appunto.hasClass("da_fare")
  old_status = "da_fare"
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
  
decremenStatus = (status) ->
  value = $(".stats li.#{status} a strong").text()
  value--
  $(".stats li.#{status} a strong").html(value)
  

if old_status isnt new_status
  decremenStatus("da-fare")    if old_status is "da_fare"
  decremenStatus("in-sospeso") if old_status is "in_sospeso"
  incrementStatus("da-fare")    if new_status is "da_fare"
  incrementStatus("in-sospeso") if new_status is "in_sospeso"