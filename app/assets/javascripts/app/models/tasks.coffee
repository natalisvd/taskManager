define [
  'chaplin'
  'app/base/collection'
  'app/models/task'
], (Ch, Collection, Task) ->
  'use strict'

  class Tasks extends Collection

    model: Task
    url: -> "/api/projects/#{@project_id}/tasks"
    active_task_id: null
    project_id: null


    initialize: (models, options) ->
      @project_id = options.project_id
      super

    newTask: ->
      task = new Task(new: true)
      @add(task, at: 0)