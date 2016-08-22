define [
  'chaplin'
  'app/base/model'
  'app/models/tasks'
  'app/models/users'
  'app/models/files'
], (Ch, Model, Tasks, Users, Files) ->
  'use strict'

  class Project extends Model

    parse: (response) ->
      if response.attach_files
        @files().reset(response.attach_files)
        delete response.attach_files
      response

    initialize: ->
      _.bindAll(@, 'checkActiveProject')
      Ch.m.subscribe 'checkActiveProject', @checkActiveProject
      super

    checkActiveProject: (id) ->
      @set('active', @get('id') is id)

    save: (attrs, options = {}) ->
      options.success = (project, r) =>
        if r.success
          @set(r.project)
          @unset('new')
          Ch.utils.redirectTo url: "/projects?project_id=#{@get('id')}"
        else
          @collection.remove(@)
          @dispose()
      super(attrs, options)

    tasks: ->
      if @_tasks
        @_tasks
      else
        @_tasks = new Tasks([], project_id: @get('id'))

    files: ->
      if @_files
        @_files
      else
        @_files = new Files([], source: 'projects', source_obj: @)

    creator: ->
      Ch.m.users.find(id: @get('creator_id'))

    dispose: ->
      Ch.m.unsubscribe 'checkActiveProject', @checkActiveProject
      super

    toggleAccess: (user) ->
      return if user.get('access_to_project') is 'creator'
      if user.get('access_to_project') is 'false'
        type = 'PUT'
      else
        type = 'DELETE'
      $.ajax
        type: type
        url: @url() + '/access'
        data: {user_id: user.get('id')}
        success: (r) ->
          if r.success
            user.set('access_to_project', r.access_to_project)