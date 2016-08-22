define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/tasks/task_item.hbs'
], (Ch, View, template) ->
  'use strict'

  class TaskItemView extends View

    template: template
    className: 'task-item-view'

    events:
      'keypress input': 'saveTask'
      'blur input': 'saveTask'

    initialize: ->
      _.bindAll(@, 'saveTask')
      @listenTo @model, 'change:active', @activeCallback
      @listenTo @model, 'change:new', @render
      @listenTo @model, 'change:title', @changeTitleCallback
      super

    getTemplateData: ->
      data = super
      data.project_id = @model.collection.project_id
      data

    afterRender: ->
      @$('input').focus() if @model.get('new')

    activeCallback: ->
      @$('a').toggleClass('active', @model.get('active'))

    saveTask: (e) ->
      if (e.keyCode is 13 or e.type is 'focusout') and @model.get('new')
        @model.save({title: @$('input').val()})

    changeTitleCallback: ->
      @$('a').html(@model.get('title'))

#    newTask: (e) ->
#      if e.keyCode is 38 #up
#        @$el.prev().find('a').click()
#      else if e.keyCode is 40 #down
#        @$el.next().find('a').click()