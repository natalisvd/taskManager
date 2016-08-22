define [
  'chaplin'
  'handlebars'
], (Chaplin, Handlebars) ->
  'use strict'

  class Layout extends Chaplin.Layout

#    autoRender: true
#
#    initialize: ->
#      console.log 'init'
#      super
#
#    render: ->
#      console.log @$el
#      super