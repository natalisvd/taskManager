define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/tasks/assigned_to_user_item.hbs'
], (Ch, View, template) ->
  'use strict'

  class AssignedToUserItemView extends View

    template: template
    className: 'assigned-to-user-item-view'
    tagName: 'li'

    events:
      'click': 'changeExecutor'

    initialize: (options) ->
      @task = options.task
      super

    changeExecutor: (e) ->
      e.preventDefault()
      @task.set('executor_id', @model.get('id'))
      @task.save()