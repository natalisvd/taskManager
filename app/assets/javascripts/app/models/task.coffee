define [
  'chaplin'
  'app/base/model'
  'app/models/task_stages'
], (Ch, Model, TaskStages) ->
  'use strict'

  class Task extends Model

    parse: (response) ->
      @taskStages().reset(response.task_stages)
      response

    initialize: ->
      _.bindAll(@, 'checkActiveTask')
      Ch.m.subscribe 'checkActiveTask', @checkActiveTask
      super

    checkActiveTask: (id) ->
      @set('active', @get('id') is id)

    executor: ->
      Ch.m.users.findWhere(id: @get('executor_id'))

    taskStages: ->
      if @_task_stages
        @_task_stages
      else
        @_task_stages = new TaskStages()

    save: (attrs, options = {}) ->
      options.success = (task, r) =>
        if r.success
          @set(r.task)
          @unset('new')
          Ch.utils.redirectTo url: "/projects?project_id=#{Ch.m.projects.getActiveProject().get('id')}&task_id=#{@get('id')}"
        else
          @collection.remove(@)
          @dispose()
      super(attrs, options)

    changeStatus: (status) ->
      $.ajax
        type: 'PUT'
        url: @url() + '/change_status'
        data: {status: status}
        success: (r) =>
          @set('status', status)