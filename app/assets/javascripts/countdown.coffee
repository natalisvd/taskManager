$(document).ready ->
  $('[data-countdown]').each ->

    $this = $(this)
    finalDate = $(this).data('countdown')
    $this.countdown finalDate, (event) ->
      $this.html event.strftime('%D days %H:%M:%S')
      $(this).on 'finish.countdown', (event) ->
        $(this).html('')