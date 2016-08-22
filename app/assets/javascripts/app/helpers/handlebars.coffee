define [
  'handlebars'
  'chaplin'
], (Handlebars, Ch) ->
  'use strict'

  Handlebars.registerHelper 'signedIn', (block) ->
    if Ch.m.user.signedIn()
      return block.fn(@)
    else
      return block.inverse(@)

  Handlebars.registerHelper 'task_status', (status) ->
    statuses =
      'opened': '<span class="label label-primary">Opened</span>'
      'in_progress': '<span class="label label-info">In progress</span>'
      'paused': '<span class="label label-warning">Paused</span>'
      'finished': '<span class="label label-default">Finished</span>'
      'returned': '<span class="label label-danger">Returned</span>'
      'closed': '<span class="label label-success">Closed</span>'
    new (Handlebars.SafeString)(statuses[status])