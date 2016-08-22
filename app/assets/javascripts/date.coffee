$(document).ready ->
  $( "#time_work_day" ).datepicker({dateFormat: 'dd-mm-yy'})
#  $( ".datefield" ).datepicker({dateFormat: 'mm-dd-yy'})
  $( ".date" ).datepicker({dateFormat: 'dd-mm-yy'})
  events = []
  $( "#task_release_date" ).datepicker({dateFormat: 'dd-mm-yy'})
  events = []
  $('#birthdaydates input').toArray().forEach (item, i, arr) ->
     events[events.length]=
     {
       Title: 'Congratulations '+item.name
       Date: new Date(item.value)
     }
  $('#releasedates input').toArray().forEach (item, i, arr) ->
    events[events.length]=
    {
      Title: 'Ho-ho-ho '+item.name
      Date: new Date(item.value)
    }

  $(".ololo").datepicker
    beforeShowDay: (date) ->
      result = [
        true
        ''
        null
      ]
      matching = $.grep(events, (event) ->
        event.Date.valueOf() == date.valueOf()
      )
      if matching.length
        result = [
          true
          'highlight'
          null
        ]
      result
    onSelect: (dateText) ->
      date = undefined
      selectedDate = new Date(dateText)
      i = 0
      event = null
      while i < events.length and !event
        date = events[i].Date
        if selectedDate.valueOf() == date.valueOf()
          event = events[i]
        i++
      events.forEach (item, i, arr) ->
#        alert(date.valueOf()+'++++++'+item.Date+'+++++++'+selectedDate.valueOf())
        if item.Date.valueOf() == selectedDate.valueOf()
          alert item.Title