define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/files/file_item.hbs'
], (Ch, View, template) ->
  'use strict'

  class FileItemView extends View

    template: template
    className: 'list-group-item file-item-view'

    initialize: ->
      @listenTo @model, 'change:path', @render
      super