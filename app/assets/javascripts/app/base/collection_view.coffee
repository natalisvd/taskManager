define [
  'chaplin'
  'handlebars'
], (Chaplin, Handlebars) ->
  'use strict'

  class CollectionView extends Chaplin.CollectionView

    constructor: (options) ->
      _.bindAll(@, 'render', 'afterRender')
      @render = _.wrap @render, (render) =>
        render()
        _.delay =>
          @afterRender() if !@disposed
        , 1
      super(options)

    getTemplateFunction: ->
      if this.template
        return Handlebars.compile(this.template)
      else
        return ''

    afterRender: -> return false