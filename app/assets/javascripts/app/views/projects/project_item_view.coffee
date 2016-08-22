define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/project_item.hbs'
], (Ch, View, template) ->
  'use strict'

  class ProjectItemView extends View

    template: template

    events:
      'keypress input': 'saveProject'
      'blur input': 'saveProject'

    initialize: ->
      _.bindAll(@, 'saveProject')
      @listenTo @model, 'change:active', @activeCallback
      @listenTo @model, 'change:new', @render
      @listenTo @model, 'change:name', @changeNameCallback
      super

    afterRender: ->
      @$('input').focus() if @model.get('new')

    activeCallback: ->
      @$('a').toggleClass('active', @model.get('active'))

    saveProject: (e) ->
      if (e.keyCode is 13 or e.type is 'focusout') and @model.get('new')
        @model.save({name: @$('input').val()})

    changeNameCallback: ->
      @$('a').html(@model.get('name'))