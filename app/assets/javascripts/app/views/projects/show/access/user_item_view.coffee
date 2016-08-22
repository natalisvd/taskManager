define [
  'chaplin'
  'app/base/view'
  'text!app/views/projects/show/access/user_item.hbs'
], (Ch, View, template) ->
  'use strict'

  class UserItemView extends View

    template: template
    className: 'list-group-item user-item-view' #list-group-item-success
    tagName: 'li'

    events:
      'click': 'toggleAccess'

    initialize: ->
      @listenTo @model, 'change:access_to_project', @toggleAccessCallback

    afterRender: ->
      @toggleAccessCallback()

    toggleAccess: ->
      Ch.m.projects.getActiveProject().toggleAccess(@model)

    toggleAccessCallback: ->
      @$el.toggleClass('list-group-item-success', @model.get('access_to_project') is 'true')