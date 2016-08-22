define [
  'chaplin'
  'app/base/collection'
  'app/models/project'
], (Ch, Collection, Project) ->
  'use strict'

  class Projects extends Collection

    model: Project
    url: '/api/projects'

    parse: (response) ->
      Ch.m.users.reset(response.users)
      response.projects

    newProject: ->
      project = new Project(new: true)
      @add(project, at: 0)

    getActiveProject: ->
      @find(active: true)