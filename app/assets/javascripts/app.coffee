require.config
  waitSeconds: 200
  urlArgs: "bust=" + (new Date()).getTime()
  paths:
    #core libs
    backbone: 'backbone.min'
    underscore: 'underscore-min'
    bootstrap: 'bootstrap-sprockets'
    chaplin: 'chaplin.min'
    handlebars: 'handlebars'
    d3: 'd3.min'
    d3gant: 'gant-chart'
    datetimepicker: 'bootstrap-datetimepicker'

    #app
    backbone_ext: 'app/base/backbone_ext'
    controllers: 'app/controllers'
    helpers: 'app/helpers'
    handlebars_helper: 'app/helpers/handlebars'
    ninja_team: 'app/ninja_team'

  shim:
    jquery:
      exports: 'jQuery'
    bootstrap:
      deps: ['jquery']

    #chaplin
    chaplin:
      deps: ['backbone', 'backbone_ext', 'jquery', 'underscore', 'handlebars']
    backbone_ext:
      deps: ['backbone']
    backbone:
      deps: ['underscore', 'jquery']
      exports: 'Backbone'
    underscore:
      exports: '_'
    handlebars:
      deps: ['jquery', 'underscore']
      exports: 'Handlebars'
    d3gant:
      deps: ['d3']
    datetimepicker:
      deps: ['moment', 'bootstrap']

    #app
    ninja_team:
      deps: ['jquery', 'bootstrap', 'chaplin', 'handlebars_helper', 'd3gant', 'datetimepicker']

require [
  'ninja_team'
  'app/routes'
], (NinjaTeam, routes) ->

  new NinjaTeam
    routes: routes
    title: 'NinjaTeam'

