define [
  'chaplin'
  'app/views/layout'
  'app/base/dispatcher'
  'app/base/router'
  'app/mediator'
  #controllers
  'controllers/projects_controller'
], (Chaplin, Layout, Dispatcher, Router, mediator, ProjectsController) ->
  'use strict'

  class NinjaTeam extends Chaplin.Application

    initialize: ->
      super

    initDispatcher: (options = {}) ->
      @dispatcher = new Dispatcher options

    initRouter: (routes, options) ->
      @router = new Router options
      routes? @router.match

    initLayout: (options = {}) ->
      options.title ?= @title
      @layout = new Layout options

    initMediator: ->
      mediator.seal()

    initControllers: ->
      new ProjectsController()

    start: ->
      Chaplin.mediator.user.fetch().then =>
        @initControllers()
        super